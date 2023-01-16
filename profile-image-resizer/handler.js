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
const targetDir=process.env.target_dir
const targetSmallSize = process.env.small_target_size
const targetSmallDir=process.env.small_target_dir
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

module.exports.resizeAvatar = async (event, context) => {
  //console.log ('******** START *********' + targetBucket + ' '+ targetSize + ' '+ targetDir + ' ') ;
  //console.log("Event: "+ JSON.stringify(event, null, 2));
  const requestUser = event.Records[0].userIdentity.principalId;
  //console.debug("Source: "+ requestUser);
  if(requestUser.indexOf(requestString)!=-1) {
    console.log("Internal event: exiting.")
    return
  }
  
  const srcBucket = event.Records[0].s3.bucket.name
  const srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " ")) ;

  let small_ok=false
  let medium_ok = false

  try {
    //console.debug("srcKey="+srcKey);
    
    const response = await s3
      .getObject({ Bucket: srcBucket, Key: srcKey })
      .promise() // `.promise()` is unconventional and specific to aws-sdk
    console.debug('Getting file from '+srcKey +' on '+srcBucket)

    const keyFolders = srcKey.split("/")
    
    try {
      await s3.headObject({
        Bucket: srcBucket, 
        Key: srcKey
      })
      .promise()

      console.log("Source already exists: " + sourceDir + keyFolders[keyFolders.length - 1] + " on " + targetBucket)
    } catch (errorFile){
      await s3.copyObject({
        Bucket: targetBucket, 
        Key: sourceDir + keyFolders[keyFolders.length - 1], 
        CopySource: srcBucket + "/" + srcKey,
        ACL:"public-read"
      })
      .promise()
      console.log("Saving to " + sourceDir + keyFolders[keyFolders.length - 1] + " on " + targetBucket)
    }
    
    /*
     * Transformations begin
     */
    function transform(data, new_size)
    {
      var image = sharp(data);
      return image
        .metadata()
        .then( function(size) {
          const neww = Math.min(size.width,new_size);
          const newh = Math.min(size.height,new_size);
          //console.debug('Resizing from ' + size.width + 'x' + size.height + " to "+ neww + 'x' + newh) ;
          return image.resize(neww, newh)
            .toBuffer() ;
        })
    }
  
    if (!pgPool) {
      await setupPgPool();
    }
    
    const resizedBuffer2 = await transform(response.Body, targetSmallSize)
    /*if(resizedBuffer)
      console.info('Saving this buffer...'+resizedBuffer) */
    const res2 = await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetSmallDir + keyFolders[keyFolders.length - 1],
          Body: resizedBuffer2,
          ACL:"public-read"
        })
      .promise()
    //console.log("Res: "+JSON.stringify(res2, null, 2))
    console.log("Saving to " + targetSmallDir + keyFolders[keyFolders.length - 1] + " on " + targetBucket)
    await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+srcBucket+"', '"+srcKey+"', '"+targetSmallDir + keyFolders[keyFolders.length - 1]+"', 'small', 'OK', NOW(), NOW()) ")
    small_ok = true
    
    const resizedBuffer = await transform(response.Body, targetSize)
    /*if(resizedBuffer)
      console.info('Saving this buffer...'+resizedBuffer) */
    const res = await s3
      .putObject({
          Bucket: targetBucket,
          Key: targetDir + keyFolders[keyFolders.length - 1],
          Body: resizedBuffer,
          ACL:"public-read"
        })
      .promise()
    //console.log("Res: "+JSON.stringify(res, null, 2))
    console.log("Saving to " + targetDir + keyFolders[keyFolders.length - 1] + " on " + targetBucket)
    await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+srcBucket+"', '"+srcKey+"', '"+targetDir + keyFolders[keyFolders.length - 1]+"', 'medium', 'OK', NOW(), NOW()) ")
    medium_ok=true

    /*
     * Transformations end
     */

    await publishMessage(process.env.channelId, 
      "Uploaded profile image resize: OK on bucket: "+srcBucket+" for file "+ srcKey
    );

  } catch (error) {
    await publishMessage(process.env.channelId, 
      "Uploaded profile image resize: ERROR on bucket: "+srcBucket
      + "\n Error: "+ JSON.stringify()
    );

    if(small_ok!==true) await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+srcBucket+"', '"+srcKey+"', '', 'medium', 'Error', NOW(), NOW()) ")
    if(small_ok!==true) await pgPool.query("insert into image_resize_actions VALUES (DEFAULT, '"+srcBucket+"', '"+srcKey+"', '', 'small', 'Error', NOW(), NOW()) ")

    console.error(error)
  }
  console.debug ('********** END ************')
}