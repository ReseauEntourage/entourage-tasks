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

``select  date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id,  
coalesce(case when sender_addresses.country = 'FR' then sender_addresses.postal_code end, 'unknown') 
from chat_messages  
join entourages on messageable_type = 'Entourage' and messageable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type = 'conversation'  
join users sender on sender.id = chat_messages.user_id  
left join addresses sender_addresses on sender_addresses.id = address_id  
where message_type = 'text'``
### publier/commenter un post (sur page événement ou action)

``select date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id, coalesce(case when country = 'FR' then postal_code end, 'unknown') 
from chat_messages  
join entourages on messageable_type = 'Entourage' and messageable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type in ('action', 'outing') 
where message_type = 'text'``
### publier/commenter un post (sur page groupe )

``select date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id, coalesce(case when country = 'FR' then postal_code end, 'unknown') 
    from chat_messages  
    join neighborhoods n  on messageable_type = 'Neighborhood' and messageable_id = n.id 
    where message_type = 'text' and n.status!='deleted'``
### créer une contribution ou demande ou un événement

``select date(timezone('Europe/Paris', created_at at time zone 'UTC')), user_id, coalesce(case when country = 'FR' then postal_code end, 'unknown') 
from entourages where entourages.community = 'entourage' and entourages.group_type in ('action', 'outing')";``

### rejoindre une contribution ou demande [users sur ancienne app]
``select date(timezone('Europe/Paris', coalesce(accepted_at, join_requests.created_at) at time zone 'UTC')), join_requests.user_id, 
coalesce(case when country = 'FR' then postal_code end, 'unknown') 
from join_requests  
join entourages on joinable_type = 'Entourage' and joinable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type ='action' 
where join_requests.status='accepted' and message is not null and trim(message, ' \\n') != ''``

### participer à un événement

``select date(timezone('Europe/Paris', coalesce(accepted_at, join_requests.created_at) at time zone 'UTC')), join_requests.user_id, 
coalesce(case when country = 'FR' then postal_code end, 'unknown') 
from join_requests  
join entourages on joinable_type = 'Entourage' and joinable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type = 'outing'
where join_requests.status='accepted'``

### créer un groupe

``SELECT user_id, created_at, postal_code
FROM public.neighborhoods
where status!='deleted' ;``

### rejoindre un groupe (ATTENTION il faut exclure le groupe de voisins associé par défaut à tout utilisateur se connectant à la v8)
``with
  users_with_groups as (
    select user_id, date_trunc('day', accepted_at) as date, 
	sum(count(distinct joinable_id)) over (partition by user_id order by  date_trunc('day', accepted_at) rows between unbounded preceding and current row) as total 
	from join_requests jr where joinable_type = 'Neighborhood' and status='accepted' and role='member'
	group by 1, 2
  )
select g.user_id, g.date, a.postal_code 
from users_with_groups g
inner join users u on u.id=g.user_id 
inner join addresses a on u.address_id = a.id where total>1;``

### voir au moins 3 contenus pédagogiques

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

