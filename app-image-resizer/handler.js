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

const dirPrefix=process.env.dir_prefix
const sourceDir=process.env.source_dir
const requestString = process.env.request_string
const targetBucket=process.env.target_bucket
//Medium Res Images
const targetMediumSize = process.env.medium_target_size
const targetMediumDir=process.env.medium_target_dir_prefix
const targetDefaultDir=process.env.default_target_dir_prefix
//Small Res Images
const targetSmallSize = process.env.small_target_size
const targetSmallDir=process.env.small_target_dir_prefix
//High Res images
const targetHighSize = process.env.high_target_size
const targetHighDir=process.env.high_target_dir_prefix

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
  console.log ('******** START *********' + targetBucket + ' '+ targetMediumSize + ' for '+ targetDefaultDir) ;
  //console.log("Event: "+ JSON.stringify(event, null, 2));
  
  const requestUser = event.Records[0].userIdentity.principalId;
  //console.debug("Source: "+ requestUser);

  //We first check that this event is not sent by internal lambda when nothing should be done
  if(requestUser.indexOf(requestString)!=-1) {
    console.log("Internal event: exiting.")
    return
  }
  
  const srcBucket = event.Records[0].s3.bucket.name
  //console.debug("srcBucket="+srcBucket);
  const srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " ")) ;
  //console.debug("srcKey="+srcKey);

  let small_ok=false
  let medium_ok = false
  let high_ok = false

  try {
    if (!pgPool) {
      await setupPgPool();
    }
  
    const response = await s3
      .getObject({ Bucket: srcBucket, Key: srcKey })
      .promise() // `.promise()` is unconventional and specific to aws-sdk
    console.debug('Getting file from '+srcKey +' on '+srcBucket)

    let targetKey  = srcKey.replace(dirPrefix, sourceDir)

    try {
      await s3.headObject({
        Bucket: srcBucket, 
        Key: srcKey
      })
      .promise()

      console.log("Source already exists: " + targetKey + " on " + targetBucket)
    } catch (errorFile){
      await s3.copyObject({
        Bucket: targetBucket, 
        Key: targetKey, 
        CopySource: srcBucket + "/" + srcKey
      })
      .promise()
      console.log("Saving to " + targetKey + " on " + targetBucket)
    }
    
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
    await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+targetBucket+"', '"+srcKey+"', '"+targetKey+"', 'small', 'OK', NOW(), NOW()) ")
    small_ok = true


    targetKey  = srcKey.replace(dirPrefix, targetMediumDir)
    const resizedBuffer = await transform(response.Body, targetMediumSize)
    //if(resizedBuffer) console.info('Saving this buffer...'+resizedBuffer) 
    const res = await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetKey,
          Body: resizedBuffer
        })
      .promise();
    let targetDefaultKey  = srcKey.replace(dirPrefix, targetDefaultDir)
      await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetDefaultKey,
          Body: resizedBuffer
        })
      .promise()
    //console.log("Res: "+JSON.stringify(res, null, 2))
    console.log("Saving to " + targetKey + " on " + targetBucket)
    await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+targetBucket+"', '"+srcKey+"', '"+targetKey+"', 'medium', 'OK', NOW(), NOW()) ")
    medium_ok = true

    targetKey  = srcKey.replace(dirPrefix, targetHighDir)
    const resizedBuffer3 = await transform(response.Body, targetHighSize)
    //if(resizedBuffer3) console.info('Saving this buffer...'+resizedBuffer) 
    const res3 = await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetKey,
          Body: resizedBuffer3
        })
      .promise()
    //console.log("Res: "+JSON.stringify(res3, null, 2))
    console.log("Saving to " + targetKey + " on " + targetBucket)
    await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+targetBucket+"', '"+srcKey+"', '"+targetKey+"', 'high', 'OK', NOW(), NOW()) ")
    high_ok = true

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

    if(medium_ok!==true) await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+targetBucket+"', '"+srcKey+"', '', 'medium', 'Error', NOW(), NOW()) ")
    if(small_ok!==true) await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+targetBucket+"', '"+srcKey+"', '', 'small', 'Error', NOW(), NOW()) ")
    if(high_ok!==true) await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+targetBucket+"', '"+srcKey+"', '', 'high', 'Error', NOW(), NOW()) ")

    console.error(error)
  }
  console.debug ('********** END ************')
}