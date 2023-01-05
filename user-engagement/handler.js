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

module.exports.agregate = async () => {
  if (!pgPool) {
    await setupPgPool();
  }

  try {
    const result1 = await pgPool.query("select max(denorm_daily_engagements.date) as max_date from denorm_daily_engagements");
    let max_date = result1.rows[0].max_date;
    
    let result_insertquery2 = "insert into denorm_daily_engagements (date, user_id, postal_code) \
      select date(timezone('Europe/Paris', created_at at time zone 'UTC')), user_id, coalesce(case when country = 'FR' then postal_code end, 'unkown') \
      from entourages where entourages.community = 'entourage' and entourages.group_type in ('action', 'outing')";
    
    let result_insertquery3 = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
      select date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id, coalesce(case when country = 'FR' then postal_code end, 'unkown') \
      from chat_messages  \
      join entourages on messageable_type = 'Entourage' and messageable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type in ('action', 'outing') \
      where message_type = 'text'  ";
    
      let result_insertquery4 = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
        select  date(timezone('Europe/Paris', chat_messages.created_at at time zone 'UTC')), chat_messages.user_id,  \
        coalesce(case when sender_addresses.country = 'FR' then sender_addresses.postal_code end, 'unkown') \
        from chat_messages  \
        join entourages on messageable_type = 'Entourage' and messageable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type = 'conversation'  \
        join users sender on sender.id = chat_messages.user_id  \
        left join addresses sender_addresses on sender_addresses.id = address_id  \
        where message_type = 'text' ";
    
      let result_insertquery5 = "insert into denorm_daily_engagements  (date, user_id, postal_code) \
        select date(timezone('Europe/Paris', coalesce(requested_at, join_requests.created_at) at time zone 'UTC')), join_requests.user_id, \
        coalesce(case when country = 'FR' then postal_code end, 'unkown') \
        from join_requests  \
        join entourages on joinable_type = 'Entourage' and joinable_id = entourages.id and entourages.community = 'entourage' and entourages.group_type in ('action', 'outing') \
        where (group_type = 'outing' or (message is not null and trim(message, ' \\n') != ''))";

      if(max_date != null) {
        result_insertquery2 += "and created_at >= '"+max_date.toISOString() + "' ";
        result_insertquery3 += "and chat_messages.created_at >= '"+max_date.toISOString() + "' ";
        result_insertquery4 += "and chat_messages.created_at >= '"+max_date.toISOString() + "' ";
        result_insertquery5 += "and coalesce(requested_at, join_requests.created_at) >= '"+max_date.toISOString() + "' ";
    }
    const conflict_string = " on conflict (date, user_id, postal_code) do nothing"
    result_insertquery2 += conflict_string;
    result_insertquery3 += conflict_string;
    result_insertquery4 += conflict_string;
    result_insertquery5 += conflict_string;

    const result2 = await pgPool.query(result_insertquery2)
    let rowCount = result2.rowCount
    const result3 = await pgPool.query(result_insertquery3)
    rowCount += result3.rowCount
    const result4 = await pgPool.query(result_insertquery4)
    rowCount += result4.rowCount
    const result5 = await pgPool.query(result_insertquery5)
    rowCount += result5.rowCount

    let start = "beginning";
    if(max_date != null ) start = max_date.toISOString();

    publishMessage(process.env.channelId, 
      "User Engagement Consolidation: OK on stage:"+process.env.stage_name+"\n "
      + rowCount + " new daily engagements from "+start+" to now."
    );
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
    publishMessage(process.env.channelId, "Error in User Engagement Consolidation on stage:"+process.env.stage_name);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: e.message,
        stage: process.env.stage_name,
      }),
    };
  }
};
