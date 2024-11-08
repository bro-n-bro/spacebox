CREATE TABLE spacebox.admin_module (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `type` String,
    `value` String
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash,
    type
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.admin_module_writer TO spacebox.admin_module AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(s, 'stargate', 'type_url') as type,
	JSONExtractString(s, 'stargate', 'value') as value
from
(
	SELECT
		`timestamp`,
		height,
		txhash,
		JSONExtractString(message, 'msg', 'propose', 'msg', 'propose', 'msgs') as propose,
		arrayJoin(JSONExtractArrayRaw(JSONExtractString(message, 'msg', 'propose', 'msg', 'propose', 'msgs'))) as s
	FROM spacebox.message
	WHERE `type` = '/cosmwasm.wasm.v1.MsgExecuteContract' and propose != '' and JSONExtractString(s, 'stargate') != ''
)
where type LIKE '/cosmos.adminmodule.adminmodule.%'