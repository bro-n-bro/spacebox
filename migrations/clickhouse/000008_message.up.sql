-- 000005_message.up.sql

-- spacebox.message definition

CREATE TABLE spacebox.message
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `type` String,
    `signer` String,
    `message` String
)
ENGINE = ReplacingMergeTree
ORDER BY (timestamp,
 height,
 txhash,
 type,
 signer)
SETTINGS index_granularity = 8192;

-- spacebox.message_writer source

CREATE MATERIALIZED VIEW spacebox.message_writer TO spacebox.message
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `type` String,
    `signer` String,
    `message` String
) AS
SELECT *
FROM
(
    SELECT
        timestamp,
        height,
        txhash,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
 'body'),
 'messages'))),
 '@type') AS type,
        signer,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
 'body'),
 'messages'))) AS message
    FROM spacebox.raw_transaction
    WHERE code = 0
);