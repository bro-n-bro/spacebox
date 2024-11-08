CREATE TABLE spacebox.interchainqueries (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `action` String,
    `query_id` Int32,
    `connection_id` String,
    `owner` String,
    `type` String,
    `kv_key` String
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.interchainqueries_writer TO spacebox.interchainqueries AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'action',attributes)[1], 'value') as action,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'query_id',attributes)[1], 'value') as query_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'connection_id',attributes)[1], 'value') as connection_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'owner',attributes)[1], 'value') as owner,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'type',attributes)[1], 'value') as type,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'kv_key',attributes)[1], 'value') as kv_key
from (
	select
		`timestamp`,
		height,
		txhash,
		arrayJoin(JSONExtractArrayRaw(events)) as event,
		JSONExtractString(event, 'type') as type,
		JSONExtractArrayRaw(event, 'attributes') as attributes,
		JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'module',attributes)[1], 'value') as module
	from spacebox.raw_transaction
	where type = 'neutron' and module = 'interchainqueries'
);
