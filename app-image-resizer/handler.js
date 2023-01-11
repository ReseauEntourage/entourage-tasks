'use strict'

const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const sharp  = require('sharp');
const pg = require('pg');

// Require the Node Slack SDK package (github.com/slackapi/node-slack-sdk)
const { WebClient, LogLevel } = require("@slack/web-api");

// WebClient instantiates a client that can call API methods
const client = new WebClient(process.env.slacktoken, {
  // LogLevel can be imported and used to make debugging simpler
  logLevel: LogLevel.ERROR
});

const pgConfig = {
  max: 1,
  connectionString: process.env.dbconnectionstring,
  ssl: { rejectUnauthorized: false },
};

// Pool will be reused for each invocation of the backing container.
let pgPool;

const setupPgPool = () => {
  pgPool = new pg.Pool(pgConfig);
};

const targetBucket=process.env.target_bucket
const targetSize = process.env.target_size
const targetDir=process.env.target_dir_prefix
const targetSmallSize = process.env.small_target_size
const targetSmallDir=process.env.small_target_dir_prefix
const dirPrefix=process.env.dir_prefix
const sourceDir=process.env.source_dir
const requestString = process.env.request_string

// Post a message to a channel your app is in using ID and message text
async function publishMessage(id, text) {
  try {
    // Call the chat.postMessage method using the built-in WebClient
    const result = await client.chat.postMessage({
      channel: id,
      text: text
    });
  }
  catch (error) {
    console.error(error);
  }
}

/*
  * Transformations begin
  */
async function transform(data, new_size)
{
  var image = sharp(data);
  return image
    .metadata()
    .then( function(size) {
      const newratio = Math.max(size.width/new_size, size.height/new_size, 1);
      const neww = Math.floor(size.width/newratio);
      const newh = Math.floor(size.height/newratio);
      console.debug('Resizing from ' + size.width + 'x' + size.height + " to "+ neww + 'x' + newh+ ' using ratio=' +newratio) ;
      return image.resize(neww, newh)
        .toBuffer() ;
    })
}

module.exports.resizeAppUpload = async (event, context) => {
  console.log ('******** START *********' + targetBucket + ' '+ targetSize + ' for '+ targetDir + ' ') ;
  //console.log("Event: "+ JSON.stringify(event, null, 2));
  const requestUser = event.Records[0].userIdentity.principalId;
  //console.debug("Source: "+ requestUser);
  if(requestUser.indexOf(requestString)!=-1) {
    console.log("Internal event: exiting.")
    return
  }
  
  const srcBucket = event.Records[0].s3.bucket.name
  //console.debug("srcBucket="+srcBucket);
  const srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " ")) ;
  //console.debug("srcKey="+srcKey);

  try {
    if (!pgPool) {
      await setupPgPool();
    }
  
    const typeMatch = srcKey.match(/\.([^.]*)$/) ;
    //TODO check if typematch a au moins 2 parts
    //console.info("typeMatch="+typeMatch);
        
    const imageType = typeMatch[1] ;
  
    const response = await s3
      .getObject({ Bucket: srcBucket, Key: srcKey })
      .promise() // `.promise()` is unconventional and specific to aws-sdk
    console.debug('Getting file from '+srcKey +' on '+srcBucket)

    let targetKey  = srcKey.replace(dirPrefix, sourceDir)
    
    await s3.copyObject({
        Bucket: targetBucket, 
        Key: targetKey, 
        CopySource: srcBucket + "/" + srcKey
      })
      .promise()
    console.log("Saving to " + targetKey + " on " + targetBucket)
    
    targetKey  = srcKey.replace(dirPrefix, targetSmallDir)
    const resizedBuffer2 = await transform(response.Body, targetSmallSize)
    //if(resizedBuffer2) console.info('Saving this buffer...'+resizedBuffer) 
    const res2 = await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetKey,
          Body: resizedBuffer2
        })
      .promise()
    //console.log("Res: "+JSON.stringify(res2, null, 2))
    console.log("Saving to " + targetKey + " on " + targetBucket)
    await pgPool.query("insert into fp_image_resize_actions VALUES ('"+targetBucket+"', '"+srcKey+"', '"+targetKey+"', 'small', NOW(), 'OK') ")


    targetKey  = srcKey.replace(dirPrefix, targetDir)
    const resizedBuffer = await transform(response.Body, targetSize)
    //if(resizedBuffer) console.info('Saving this buffer...'+resizedBuffer) 
    const res = await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetKey,
          Body: resizedBuffer
        })
      .promise()
    //console.log("Res: "+JSON.stringify(res, null, 2))
    console.log("Saving to " + targetKey + " on " + targetBucket)
    await pgPool.query("insert into fp_image_resize_actions VALUES ('"+targetBucket+"', '"+srcKey+"', '"+targetKey+"', 'medium', NOW(), 'OK') ")

    /*
     * Transformations end
     */
    await publishMessage(process.env.channelId, 
      "Uploaded image resize: OK on bucket: "+targetBucket+" for file "+ srcKey
    );

  } catch (error) {
    await publishMessage(process.env.channelId, 
      "Uploaded image resize: ERROR on bucket: "+targetBucket
      + "\n Error: "+ JSON.stringify()
    );

    await pgPool.query("insert into fp_image_resize_actions VALUES ('"+targetBucket+"', '"+srcKey+"', '', 'medium', NOW(), 'Error') ")
    await pgPool.query("insert into fp_image_resize_actions VALUES ('"+targetBucket+"', '"+srcKey+"', '', 'small', NOW(), 'Error') ")

    console.error(error)
  }
  console.debug ('********** END ************')
}