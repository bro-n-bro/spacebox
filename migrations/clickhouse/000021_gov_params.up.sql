-- 000021_gov_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.gov_params_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'gov_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.gov_params
(
    `deposit_params` String,
    `voting_params`  String,
    `tally_params`   String,
    `height`         Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS gov_params_consumer TO spacebox.gov_params
AS
SELECT JSONExtractString(message, 'deposit_params') as deposit_params,
       JSONExtractString(message, 'voting_params')  as voting_params,
       JSONExtractString(message, 'tally_params')   as tally_params,
       JSONExtractInt(message, 'height')            as height
FROM spacebox.gov_params_topic
GROUP BY deposit_params, voting_params, tally_params, height;