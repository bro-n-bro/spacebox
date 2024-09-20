CREATE TABLE spacebox.address (
    address String,
    height Int32
) ENGINE = ReplacingMergeTree()
ORDER BY address
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.address_writer TO spacebox.address AS
SELECT
     arrayJoin(extractAll(logs, 'neutron[a-z0-9]{38}')) AS address,
     height
FROM
     spacebox.raw_transaction
WHERE
     logs LIKE '%neutron%';
