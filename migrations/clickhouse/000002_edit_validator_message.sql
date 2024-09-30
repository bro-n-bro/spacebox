CREATE TABLE IF NOT EXISTS spacebox.edit_validator_message
(
    `timestamp` DateTime,
    `height`      Int64,
    `tx_hash`     String,
    `description` String
) ENGINE = MergeTree()
      ORDER BY (`timestamp`, `height`, `tx_hash`);


CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.edit_validator_message_writer
TO spacebox.edit_validator_message AS
select
    height,
    `timestamp`,
    txhash as tx_hash,
    JSONExtractString(msg, 'description') as description
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
    where type = '/cosmos.staking.v1beta1.MsgEditValidator' and code = 0
)
