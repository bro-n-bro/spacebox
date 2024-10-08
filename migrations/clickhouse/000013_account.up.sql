CREATE TABLE spacebox.account (
    `address` String,
    `height` Int32,
    `timestamp` DateTime
) ENGINE = ReplacingMergeTree()
ORDER BY address
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.account_writer TO spacebox.account AS
SELECT
     arrayJoin(extractAll(logs, 'neutron[a-z0-9]{38}')) AS address,
     height,
     timestamp
FROM
     spacebox.raw_transaction
WHERE
     logs LIKE '%neutron%';
