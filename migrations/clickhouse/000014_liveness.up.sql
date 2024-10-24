CREATE TABLE spacebox.liveness (
    `height` Int32,
    `timestamp` DateTime,
    `address` String,
    `missed_blocks` Int32
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.liveness_writer TO spacebox.liveness AS
SELECT
	height,
	`timestamp`,
	JSONExtractString(
		arrayFilter(
			x -> JSONExtractString(x, 'key') = 'address',
			JSONExtractArrayRaw(JSONExtractString(item, 'attributes'))
		)[1],
		'value'
	) as address,
	JSONExtractString(
		arrayFilter(
			x -> JSONExtractString(x, 'key') = 'missed_blocks',
			JSONExtractArrayRaw(JSONExtractString(item, 'attributes'))
		)[1],
		'value'
	) as missed_blocks
from (
	select
		height,
		`timestamp`,
		arrayJoin(JSONExtractArrayRaw(finalize_block_events)) as item from spacebox.raw_block_results
	where JSONExtractString(item, 'type') = 'liveness'
)