'use strict';

const pg = require('pg');

const pgConfig = {
  max: 1,
  connectionString: process.env.dbconnectionstring,
  ssl: { rejectUnauthorized: false },
};

// Require the Node Slack SDK package (github.com/slackapi/node-slack-sdk)
const { WebClient, LogLevel } = require("@slack/web-api");

// WebClient instantiates a client that can call API methods
const client = new WebClient(process.env.slacktoken, {
  // LogLevel can be imported and used to make debugging simpler
  logLevel: LogLevel.ERROR
});

// Pool will be reused for each invocation of the backing container.
let pgPool;

const setupPgPool = () => {
  pgPool = new pg.Pool(pgConfig);
};

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

module.exports.aggregate = async () => {
  if (!pgPool) {
    await setupPgPool();
  }

  try {
    const result1 = await pgPool.query("select max(denorm_daily_engagements.date) as max_date from denorm_daily_engagements");
    let max_date = result1.rows[0].max_date;
    
    let insertqueryCreateActionEvent = "insert into denorm_daily_engagements (date, user_id, postal_code) \
      select date(timezone('Europe/Paris', created_at at time zone 'UTC')), user_id, coalesce(postal_code, 'unknown') \
      from entourages where entourages.community = 'entourage' and entourages.group_type in ('action', 'outing')";
    
    let insertqueryPostInActionEvent = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
    select date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id, coalesce(postal_code, 'unknown') \
    from chat_messages  \
    join entourages on messageable_type = 'Entourage' and messageable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type in ('action', 'outing') \
    where message_type = 'text'  ";
  
    let insertqueryPostInGroup = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
    select date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id, coalesce(postal_code, 'unknown') \
    from chat_messages  \
    join neighborhoods n  on messageable_type = 'Neighborhood' and messageable_id = n.id \
    where message_type = 'text' and n.status!='deleted'  ";
  
    let insertqueryPostMessages = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
        select  date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id,  \
        coalesce(case when sender_addresses.country = 'FR' then sender_addresses.postal_code end, 'unknown') \
        from chat_messages  \
        join entourages on messageable_type = 'Entourage' and messageable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type = 'conversation'  \
        join users sender on sender.id = chat_messages.user_id  \
        left join addresses sender_addresses on sender_addresses.id = address_id  \
        where message_type = 'text' ";
      
    let insertqueryJoinAction = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
    select date(timezone('Europe/Paris', coalesce(accepted_at, join_requests.created_at) at time zone 'UTC')), join_requests.user_id, \
    coalesce(case when country = 'FR' then postal_code end, 'unknown') \
    from join_requests  \
    join entourages on joinable_type = 'Entourage' and joinable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type='action' \
    where join_requests.status='accepted' and message is not null and trim(message, ' \\n') != ''";

    let insertqueryJoinEvent = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
    select date(timezone('Europe/Paris', coalesce(accepted_at, join_requests.created_at) at time zone 'UTC')), join_requests.user_id, \
    coalesce(case when country = 'FR' then postal_code end, 'unknown') \
    from join_requests  \
    join entourages on joinable_type = 'Entourage' and joinable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type = 'outing' \
    where join_requests.status='accepted' ";

    let insertqueryWatchResources = "with user_watchlist as ( \
      select user_id, date_trunc('day', created_at) as date, \
      sum(count(distinct resource_id)) over (partition by user_id order by  date_trunc('day', created_at) rows between unbounded preceding and current row) as total \
      from users_resources ur where watched =true group by 1, 2)\
      insert into denorm_daily_engagements  (date, user_id, postal_code) \
      select date, user_id, 'unknown' from user_watchlist where total >=3";

    let insertqueryCreationGroup = " insert into denorm_daily_engagements  (date, user_id, postal_code) \
      SELECT date(timezone('Europe/Paris', created_at at time zone 'UTC')), user_id, postal_code \
      FROM public.neighborhoods where status!='deleted'";
    
    let insertQueryUsersWithGroups = "with users_with_groups as ( \
      select user_id, date_trunc('day', accepted_at) as date,  \
      sum(count(distinct joinable_id))  \
      over (partition by user_id order by  date_trunc('day', accepted_at) rows between unbounded preceding and current row) as total  \
      from join_requests jr  \
      where joinable_type = 'Neighborhood' and status='accepted' and role='member' \
      group by 1, 2) \
      insert into denorm_daily_engagements  (user_id, date, postal_code) \
      select g.user_id, g.date, coalesce(case when country = 'FR' then postal_code end, 'unknown')  \
      from users_with_groups g \
      inner join users u on u.id=g.user_id  \
      inner join addresses a on u.address_id = a.id where total>1 "

    if(max_date != null) {
      insertqueryCreateActionEvent += " and created_at >= '"+max_date.toISOString() + "' ";
      insertqueryCreationGroup += " and created_at >= '"+max_date.toISOString() + "' ";
      insertqueryPostInActionEvent += " and chat_messages.created_at >= '"+max_date.toISOString() + "' ";
      insertqueryPostInGroup += " and chat_messages.created_at >= '"+max_date.toISOString() + "' ";
      insertqueryPostMessages += " and chat_messages.created_at >= '"+max_date.toISOString() + "' ";
      insertqueryJoinAction += " and coalesce(accepted_at, join_requests.created_at) >= '"+max_date.toISOString() + "' ";
      insertqueryJoinEvent += " and coalesce(accepted_at, join_requests.created_at) >= '"+max_date.toISOString() + "' ";
      insertqueryWatchResources += " and date >= '"+max_date.toISOString() + "' ";
      insertQueryUsersWithGroups += " and date >= '"+max_date.toISOString() + "' ";
    }
    
    const conflict_string = " on conflict (date, user_id, postal_code) do nothing"
    insertqueryCreateActionEvent += conflict_string;
    insertqueryPostInActionEvent += conflict_string;
    insertqueryPostInGroup += conflict_string;
    insertqueryPostMessages += conflict_string;
    insertqueryJoinAction += conflict_string;
    insertqueryJoinEvent += conflict_string;
    insertqueryWatchResources += conflict_string;
    insertqueryCreationGroup += conflict_string;
    insertQueryUsersWithGroups += conflict_string

    const result2 = await pgPool.query(insertqueryCreateActionEvent)
    let rowCount = result2.rowCount
    const resultPostInActionEvent = await pgPool.query(insertqueryPostInActionEvent)
    rowCount += resultPostInActionEvent.rowCount
    const resultPostInGroup = await pgPool.query(insertqueryPostInGroup)
    rowCount += resultPostInGroup.rowCount
    const result4 = await pgPool.query(insertqueryPostMessages)
    rowCount += result4.rowCount
    const result50 = await pgPool.query(insertqueryJoinAction)
    rowCount += result50.rowCount
    const result5 = await pgPool.query(insertqueryJoinEvent)
    rowCount += result5.rowCount
    const resultWatchResources = await pgPool.query(insertqueryWatchResources)
    rowCount += resultWatchResources.rowCount
    const resultCreationGroup = await pgPool.query(insertqueryCreationGroup)
    rowCount += resultCreationGroup.rowCount
    const resultUsersWithGroups = await pgPool.query(insertQueryUsersWithGroups)
    rowCount += resultUsersWithGroups.rowCount

    /*let start = "beginning";
    if(max_date != null ) start = max_date.toISOString();

    await publishMessage(process.env.channelId, 
      "User Engagement Consolidation: OK on stage:"+process.env.stage_name+"\n "
      + rowCount + " new daily engagements from "+start+" to now."
    );*/
    // Response body must be JSON.
    return {
      statusCode: 200,
      body: JSON.stringify({
        output: {
          max_date,
          rowCount
        },
        stage: process.env.stage_name,
      }),
    };
  } catch (e) {
    await publishMessage(process.env.channelId, "Error in User Engagement Consolidation on stage:"+process.env.stage_name);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: e.message,
        stage: process.env.stage_name,
      }),
    };
  }
}
