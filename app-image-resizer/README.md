# Intro 

Deployment on AWS is done manually every time we update this repository

**To do**: more details


## Description
Images are uplpoaded to directories (announcements, chat_messages, contributions, entourage_images, neighborhoods, organizations, recommandations, resources) by user
Lambda function copies original file to source dir,
then resizes it to 400x400 pixels max in root dir,
then resizes it to 60x60 pixels max in small dir,


## DEPLOY:

> sls deploy -s dev

> sls deploy -s staging

> sls deploy -s prod

Upload time: around 70s

## External lib

Sharp: https://sharp.pixelplumbing.com/changelog


### Optionnal commands
To touch existing files (**already done! DO NOT DO IT AGAIN**):

>aws s3 cp --metadata {\"touched\":\"true\"}  s3://entourage-images-production/entourage_images/ s3://entourage-images-production/entourage_images/ --recursive

Should be done for all subdir

> aws s3 cp --metadata {\"touched\":\"true\"}  s3://entourage-images-development/entourage_images/testFPimageEntourage.jpeg s3://entourage-images-development/entourage_images/testFPimageEntourage.jpeg

Copying Staging files for Dev

> aws s3 cp s3://entourage-images-development/staging/source/ s3://entourage-images-development/ --recursive

> serverless config credentials --provider aws --key /*key*/ --secret /*secret*/

> serverless --version

> serverless create --template aws-nodejs --path resize_app_upload

> serverless invoke local --function resize-app-upload -p ./test/event.json --stage prod

> serverless invoke local --function resize-app-upload -p ./test/event_dev.json --stage dev

## TO DO 
- record action into BDD
- handle PNG files

aws s3 cp s3://entourage-avatars-production-thumb/staging/300x300/testFPavatarEntourage.jpeg s3://entourage-images-production/entourage_images/testFPimageEntourage.jpeg

aws s3 cp s3://entourage-avatars-production-thumb/staging/300x300/testFPavatarEntourage.jpeg s3://entourage-images-development/staging/entourage_images/testFPimageEntourage.jpeg


aws s3 rm s3://entourage-images-development/staging/source/entourage_images/testFPimageEntourage.jpeg
aws s3 rm s3://entourage-images-development/staging/medium/entourage_images/testFPimageEntourage.jpeg
aws s3 rm s3://entourage-images-development/staging/small/entourage_images/testFPimageEntourage.jpeg
aws s3 rm s3://entourage-images-development/staging/entourage_images/testFPimageEntourage.jpeg

aws s3 rm s3://entourage-images-development/source/staging/entourage_images/testFPimageEntourage.jpeg
aws s3 rm s3://entourage-images-development/small/staging/entourage_images/testFPimageEntourage.jpeg

aws s3 cp s3://entourage-avatars-production-thumb/staging/300x300/testFPavatarEntourage.jpeg s3://entourage-images-development/staging/entourage_images/testFPimageEntourage.jpeg

aws s3 ls entourage-images-development/staging/entourage_images/testFPimageEntourage.jpeg
aws s3 ls entourage-images-development/staging/source/entourage_images/testFPimageEntourage.jpeg
aws s3 ls entourage-images-development/staging/medium/entourage_images/testFPimageEntourage.jpeg
aws s3 ls entourage-images-development/staging/small/entourage_images/testFPimageEntourage.jpeg
 

aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/entourage_images/ s3://entourage-images-development/staging/entourage_images/ --recursive

aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/announcements/ s3://entourage-images-development/staging/announcements/ --recursive
aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/chat_messages/ s3://entourage-images-development/staging/chat_messages/ --recursive
aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/contributions/ s3://entourage-images-development/staging/contributions/ --recursive
aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/neighborhoods/ s3://entourage-images-development/staging/neighborhoods/ --recursive
aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/organizations/ s3://entourage-images-development/staging/organizations/ --recursive
aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/recommandations/ s3://entourage-images-development/staging/recommandations/ --recursive
aws s3 cp --metadata {\"touched\":\"true\"} s3://entourage-images-development/staging/resources/ s3://entourage-images-development/staging/resources/ --recursive
