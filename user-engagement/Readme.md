# Tools
## AWS Lambda

You will need an access key with **proper rights** to upload and run on AWS lambda

https://eu-west-1.console.aws.amazon.com/lambda/home?region=eu-west-1

## serverless Framework

https://www.serverless.com/

### CLI

install on Windows: 
>choco install serverless


# Set-up
Lambda are runing on AWS in Ireland

They are using **node.JS 14**

There are two stages: **'dev' and 'prod'**

Dev is working on Preprod env.

Prod is working on Production env.    

The lambda are triggered by a **cron** defined like this
> cron(0 5 * * ? *)

Meaning it is triggered every day at 5:00 UTC

Messages are sent to **Slack** using an custom App called "AWS Lambda Slack App"
> slacktoken: ${ssm:/ENTOURAGE_AWS_LAMBDA_APP_SLACK_TOKEN}

> channelId: 'CRNGQU2K1'

This channel is 'backenddev'

## Secret Variables
They are stored in AWS **SSM** (here: )

dev db connection string: 'PREPROD_DATABASE_URL'

prod db connection string: 'PRODUCTION_DATABASE_URL'

slack token: 'ENTOURAGE_AWS_LAMBDA_APP_SLACK_TOKEN'

# Tests

>serverless invoke local -s dev -f aggregate

>serverless invoke local -s prod -f aggregate

# Deploy new version

>serverless deploy -s dev

>serverless deploy -s prod

Process time is around 190s
