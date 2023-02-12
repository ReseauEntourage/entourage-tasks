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
## Engagement criterias

Avec la nouvelle app, on aimerait qu'un utilisateur soit considéré comme engagé si il fait au moins l'une de ces actions :

### envoyer un message privé (messagerie)
### publier un post (sur page groupe ou événement)
### commenter un post (sur page groupe ou événement)
### créer une contribution ou demande
### rejoindre une contribution ou demande [users sur ancienne app]
### créer un événement
### participer à un événement
### créer un groupe
## rejoindre un groupe (ATTENTION il faut exclure le groupe de voisins associé par défaut à tout utilisateur se connectant à la v8)
## voir au moins 3 contenus pédagogiques

``with
  user_watchlist as (
    select user_id, date_trunc('day', created_at) as date, 
	sum(count(distinct resource_id)) over (partition by user_id order by  date_trunc('day', created_at) rows between unbounded preceding and current row) as total 
	from users_resources ur where watched =true
	group by 1, 2
  )
select date, user_id 
from user_watchlist
where total >=3;``

