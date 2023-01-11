# Intro 

Deployment on AWS is done manually every time we update this repository

**To do**: more details


## Description
Avatars are uplpoaded to 300x300 by user
Lambda function copies file to source dir,
then resizes it to 300x300 pixels max in 300x300 dir,
then resizes it to 60x60 pixels max in 60x00 dir,


## DEPLOY:

> sls deploy -s dev

> sls deploy -s staging

> sls deploy -s prod

## External lib

Sharp: https://sharp.pixelplumbing.com/changelog


### Optionnal commands
To touch existing files (**already done! DO NOT DO IT AGAIN**):

>aws s3 cp --metadata {\"touched\":\"true\"}  s3://entourage-avatars-production-thumb/300x300/ s3://entourage-avatars-production-thumb/300x300/ --recursive

> aws s3 cp --metadata {\"touched\":\"true\"}  s3://entourage-avatars-staging/users/300x300/testFPavatarEntourage.jpeg s3://entourage-avatars-staging/users/300x300/testFPavatarEntourage.jpeg

> aws s3 cp s3://entourage-avatars-production-thumb/staging/source/ s3://entourage-avatars-staging/users/300x300/ --recursive

> serverless config credentials --provider aws --key /*key*/ --secret /*secret*/

> serverless --version

> serverless create --template aws-nodejs --path resize_avatar

> serverless invoke local --function resize-avatar -p ./test/event.json --stage prod

> serverless invoke local --function resize-avatar -p ./test/event_dev.json --stage dev

## TO DO 