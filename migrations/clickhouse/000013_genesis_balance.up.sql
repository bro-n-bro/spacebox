-- spacebox.genesis_balances definition

CREATE TABLE spacebox.genesis_balances
(

    `height` Int64,
    `type` String,
    `address` String,
    `amount` Int64,
    `denom` String
)
ENGINE = MergeTree
ORDER BY (height,
 address,
 denom)
SETTINGS index_granularity = 8192;

insert into spacebox.genesis_balances
select
	0 as height,
	'coin_received' as type,
	address,
	JSONExtractString(coin, 'amount') as amount,
	JSONExtractString(coin, 'denom') as denom
from (
	select
		JSONExtractString(balance, 'address') as address,
		arrayJoin(JSONExtractArrayRaw(JSONExtractString(balance, 'coins'))) as coin
	from (
		select
			arrayJoin(JSONExtractArrayRaw(JSONExtractString(app_state, 'bank', 'balances')))  as balance
		from spacebox.raw_genesis
	)
)
