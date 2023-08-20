-- 000022_proposal.up.sql
CREATE TABLE IF NOT EXISTS spacebox.proposal_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'proposal', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.proposal
(
    `id`                Int64,
    `title`             String,
    `description`       String,
    `content`           String,
    `proposal_route`    String,
    `proposal_type`     String,
    `submit_time`       TIMESTAMP,
    `deposit_end_time`  TIMESTAMP,
    `voting_start_time` TIMESTAMP,
    `voting_end_time`   TIMESTAMP,
    `proposer_address`  String,
    `status`            String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`id`);

CREATE MATERIALIZED VIEW IF NOT EXISTS proposal_consumer TO spacebox.proposal
AS
SELECT JSONExtractInt(message, 'id')                                                  as id,
       JSONExtractString(message, 'title')                                            as title,
       JSONExtractString(message, 'description')                                      as description,
       FROM_BASE64(JSONExtractString(message, 'content'))                             as content,
       JSONExtractString(message, 'proposal_route')                                   as proposal_route,
       JSONExtractString(message, 'proposal_type')                                    as proposal_type,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'submit_time'))       as submit_time,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'deposit_end_time'))  as deposit_end_time,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'voting_start_time')) as voting_start_time,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'voting_end_time'))   as voting_end_time,
       JSONExtractString(message, 'proposer_address')                                 as proposer_address,
       JSONExtractString(message, 'status')                                           as status
FROM spacebox.proposal_topic
GROUP BY id, title, description, content, proposal_route, proposal_type, submit_time, deposit_end_time,
         voting_start_time, voting_end_time, proposer_address, status;