CREATE TABLE spacebox.cyberlinks
(
	`timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `signer` String,
    `particleFrom` String,
    `particleTo` String,
    `neuron` String
)
ENGINE = ReplacingMergeTree
ORDER BY (
 particleFrom,
 particleTo,
 neuron)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.cyberlinks_writer TO spacebox.cyberlinks AS
WITH filtered_cyberlinks AS (
	SELECT
		`timestamp`,
		height,
		txhash,
		signer,
		arrayJoin(JSONExtractArrayRaw(JSONExtractString(arrayJoin(JSONExtractArrayRaw(raw_log)), 'events'))) AS event,
		JSONExtractString(event, 'type') as type
	FROM spacebox.raw_transaction
	WHERE type = 'cyberlink' and code = 0
), json_cyberlinks AS (
	SELECT
		`timestamp`,
		height,
		txhash,
		signer,
		JSONExtractString(event, 'attributes') as attributes
	 FROM filtered_cyberlinks
),expanded_data AS (
    SELECT
    	*,
    	JSONExtractArrayRaw(attributes) as arr,
    	arrayEnumerate(JSONExtractArrayRaw(attributes)) AS idx,
        arrayJoin(arrayMap(
        	(x, i) ->
            multiIf(
            	JSONExtractString(arr[i], 'key') = 'particleFrom' AND JSONExtractString(arr[i+1], 'key') = 'particleTo' AND JSONExtractString(arr[i+2], 'key') = 'neuron',
            	(JSONExtractString(arr[i], 'value'), JSONExtractString(arr[i+1], 'value'), JSONExtractString(arr[i+2], 'value')),
            	JSONExtractString(arr[i], 'key') = 'particleFrom' AND JSONExtractString(arr[i+1], 'key') = 'particleTo' AND JSONExtractString(arr[i+2], 'key') != 'neuron',
            	(JSONExtractString(arr[i], 'value'), JSONExtractString(arr[i+1], 'value'), JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'key') = 'neuron', arr), 'value')),
            	('', '', '')
            ),
            arr,
            idx
        )) AS data
    FROM json_cyberlinks
)
SELECT
	`timestamp`,
	height,
	txhash,
	signer,
	data.1 as particleFrom,
	data.2 as particleTo,
	data.3 as neuron
FROM expanded_data
WHERE neuron != ''
ORDER BY height DESC;