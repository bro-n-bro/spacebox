-- 000003_genesis_balances.up.sql

-- spacebox.genesis_balances definition

CREATE TABLE spacebox.genesis_balances
(
    `height` Int64,
    `type` String,
    `address` String,
    `coins` String,
    `amount` Int64,
    `denom` String
)
ENGINE = MergeTree
ORDER BY (height,
 address,
 denom)
SETTINGS index_granularity = 8192;

INSERT INTO spacebox.debs_and_creds 
WITH raw_balances AS (
	SELECT 
		arrayJoin(JSONExtractArrayRaw(JSONExtractString(app_state, 'bank', 'balances'))) AS raw
	FROM spacebox.raw_genesis
)
SELECT
	0 as height,
	'coin_received' as type,
	JSONExtractString(raw, 'address') AS address,
	arrayJoin(JSONExtractArrayRaw(raw, 'coins')) AS coins,
	toInt64OrZero(JSONExtractString(coins, 'amount')) as amount,
	JSONExtractString(coins, 'denom') as denom
FROM raw_balances;