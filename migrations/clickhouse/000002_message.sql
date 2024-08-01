CREATE TABLE spacebox.message
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `type` String,
    `signer` String,
    `message` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 type,
 signer)


CREATE MATERIALIZED VIEW spacebox.message_writer TO spacebox.message AS
SELECT
    timestamp,
    height,
    txhash,
    arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx,
 'body',
 'messages'))) AS message,
    JSONExtractString(msg,
 '@type') AS type,
    signer
FROM spacebox.raw_transaction;

