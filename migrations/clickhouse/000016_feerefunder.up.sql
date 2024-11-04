CREATE TABLE spacebox.feerefunder_lock_fees (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `channel_id` String,
    `payer` String,
    `port_id` String,
    `sequence` Int32
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.feerefunder_lock_fees_writer TO spacebox.feerefunder_lock_fees AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'channel_id',attributes)[1], 'value') as channel_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'payer',attributes)[1], 'value') as payer,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'port_id',attributes)[1], 'value') as port_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'sequence',attributes)[1], 'value') as sequence
from (
	select
		`timestamp`,
		height,
		txhash,
		arrayJoin(JSONExtractArrayRaw(events)) as event,
		JSONExtractString(event, 'type') as type,
		JSONExtractArrayRaw(event, 'attributes') as attributes
	from spacebox.raw_transaction
	where type = 'lock_fees'
);



CREATE TABLE spacebox.feerefunder_distribute_ack_fee (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `channel_id` String,
    `receiver` String,
    `port_id` String,
    `sequence` Int32
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.feerefunder_distribute_ack_fee_writer TO spacebox.feerefunder_distribute_ack_fee AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'channel_id',attributes)[1], 'value') as channel_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'receiver',attributes)[1], 'value') as receiver,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'port_id',attributes)[1], 'value') as port_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'sequence',attributes)[1], 'value') as sequence
from (
	select
		`timestamp`,
		height,
		txhash,
		arrayJoin(JSONExtractArrayRaw(events)) as event,
		JSONExtractString(event, 'type') as type,
		JSONExtractArrayRaw(event, 'attributes') as attributes
	from spacebox.raw_transaction
	where type = 'distribute_ack_fee'
);

CREATE TABLE spacebox.feerefunder_distribute_timeout_fee (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `channel_id` String,
    `receiver` String,
    `port_id` String,
    `sequence` Int32
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.feerefunder_distribute_timeout_fee TO spacebox.feerefunder_distribute_timeout_fee AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'channel_id',attributes)[1], 'value') as channel_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'receiver',attributes)[1], 'value') as receiver,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'port_id',attributes)[1], 'value') as port_id,
	JSONExtractString(arrayFilter( x -> JSONExtractString(x, 'key') = 'sequence',attributes)[1], 'value') as sequence
from (
	select
		`timestamp`,
		height,
		txhash,
		arrayJoin(JSONExtractArrayRaw(events)) as event,
		JSONExtractString(event, 'type') as type,
		JSONExtractArrayRaw(event, 'attributes') as attributes
	from spacebox.raw_transaction
	where type = 'distribute_timeout_fee'
);