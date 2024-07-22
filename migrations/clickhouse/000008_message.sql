CREATE TABLE IF NOT EXISTS spacebox.message
(
    `timestamp` DateTime,
    `transaction_hash` String,
    `msg_index`        Int64,
    `type`             String,
    `signer`           String,
    `value`            String
) ENGINE = MergeTree()
      ORDER BY (`transaction_hash`, `type`, `timestamp`, `signer`);


CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.message_writer
TO spacebox.message AS
select
    height,
    `timestamp`,
    type,
    signer,
    msg as value,
    txhash as transaction_hash
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
)