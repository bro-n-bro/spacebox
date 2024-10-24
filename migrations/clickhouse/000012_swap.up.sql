-- spacebox.swap definition

CREATE TABLE spacebox.swap
(
    `height` Int64,
    `timestamp` DateTime,
    `pool_id` UInt32,
    `batch_index` UInt32,
    `swap_requester` String,
    `offer_coin_denom` String,
    `offer_coin_amount` Float64,
    `demand_coin_denom` String,
    `exchanged_demand_coin_amount` Float64,
    `transacted_coin_amount` Float64,
    `remaining_offer_coin_amount` Float64,
    `offer_coin_fee_amount` Float64,
    `order_expiry_height` Int64,
    `exchanged_coin_fee_amount` Float64,
    `order_price` Float64,
    `swap_price` Float64,
    `success` Bool
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 pool_id,
 swap_requester,
 offer_coin_denom,
 demand_coin_denom)
SETTINGS index_granularity = 8192;


-- spacebox.swap_writer source

CREATE MATERIALIZED VIEW spacebox.swap_writer TO spacebox.swap
(

    `height` Int64,

    `timestamp` DateTime,

    `pool_id` String,

    `batch_index` String,

    `swap_requester` String,

    `offer_coin_denom` String,

    `offer_coin_amount` String,

    `demand_coin_denom` String,

    `exchanged_demand_coin_amount` String,

    `transacted_coin_amount` String,

    `remaining_offer_coin_amount` String,

    `offer_coin_fee_amount` String,

    `order_expiry_height` String,

    `exchanged_coin_fee_amount` String,

    `order_price` String,

    `swap_price` String,

    `success` Bool
)
AS SELECT
    height,
    timestamp,
    pool_id,
    batch_index,
    swap_requester,
    offer_coin_denom,
    offer_coin_amount,
    demand_coin_denom,
    exchanged_demand_coin_amount,
    transacted_coin_amount,
    remaining_offer_coin_amount,
    offer_coin_fee_amount,
    order_expiry_height,
    exchanged_coin_fee_amount,
    order_price,
    swap_price,
    success
FROM
(
    SELECT
        height,
        timestamp,
        arrayJoin(JSONExtractArrayRaw(end_block_events)) AS event,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'cG9vbF9pZA=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS pool_id,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'YmF0Y2hfaW5kZXg='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS batch_index,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'c3dhcF9yZXF1ZXN0ZXI='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS swap_requester,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'b2ZmZXJfY29pbl9kZW5vbQ=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS offer_coin_denom,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'b2ZmZXJfY29pbl9hbW91bnQ='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS offer_coin_amount,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'ZGVtYW5kX2NvaW5fZGVub20='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS demand_coin_denom,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'ZXhjaGFuZ2VkX2RlbWFuZF9jb2luX2Ftb3VudA=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS exchanged_demand_coin_amount,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'dHJhbnNhY3RlZF9jb2luX2Ftb3VudA=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS transacted_coin_amount,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'cmVtYWluaW5nX29mZmVyX2NvaW5fYW1vdW50'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS remaining_offer_coin_amount,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'b2ZmZXJfY29pbl9mZWVfYW1vdW50'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS offer_coin_fee_amount,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'b3JkZXJfZXhwaXJ5X2hlaWdodA=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS order_expiry_height,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'ZXhjaGFuZ2VkX2NvaW5fZmVlX2Ftb3VudA=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS exchanged_coin_fee_amount,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'b3JkZXJfcHJpY2U='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS order_price,
        base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'c3dhcF9wcmljZQ=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) AS swap_price,
        if(base64Decode(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'c3VjY2Vzcw=='),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value')) = 'success',
 true,
 false) AS success
    FROM
    (
        SELECT *
        FROM spacebox.raw_block_results
        WHERE end_block_events ILIKE '%swap_transacted%' and height < 15515000
    )
    WHERE JSONExtractString(event,
 'type') = 'swap_transacted'
);

-- spacebox.swap_writer for new blocks source


CREATE MATERIALIZED VIEW spacebox.swap_new_blocks_writer TO spacebox.swap
(

    `height` Int64,

    `timestamp` DateTime,

    `pool_id` String,

    `batch_index` String,

    `swap_requester` String,

    `offer_coin_denom` String,

    `offer_coin_amount` String,

    `demand_coin_denom` String,

    `exchanged_demand_coin_amount` String,

    `transacted_coin_amount` String,

    `remaining_offer_coin_amount` String,

    `offer_coin_fee_amount` String,

    `order_expiry_height` String,

    `exchanged_coin_fee_amount` String,

    `order_price` String,

    `swap_price` String,

    `success` Bool
)
AS SELECT
    height,
    timestamp,
    pool_id,
    batch_index,
    swap_requester,
    offer_coin_denom,
    offer_coin_amount,
    demand_coin_denom,
    exchanged_demand_coin_amount,
    transacted_coin_amount,
    remaining_offer_coin_amount,
    offer_coin_fee_amount,
    order_expiry_height,
    exchanged_coin_fee_amount,
    order_price,
    swap_price,
    success
FROM
(
    SELECT
        height,
        timestamp,
        arrayJoin(JSONExtractArrayRaw(end_block_events)) AS event,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'pool_id'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS pool_id,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'batch_index'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS batch_index,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'swap_requester'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS swap_requester,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'offer_coin_denom'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS offer_coin_denom,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'offer_coin_amount'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS offer_coin_amount,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'demand_coin_denom'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS demand_coin_denom,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'exchanged_demand_coin_amount'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS exchanged_demand_coin_amount,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'transacted_coin_amount'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS transacted_coin_amount,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'remaining_offer_coin_amount'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS remaining_offer_coin_amount,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'offer_coin_fee_amount'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS offer_coin_fee_amount,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'order_expiry_height'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS order_expiry_height,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'exchanged_coin_fee_amount'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS exchanged_coin_fee_amount,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'order_price'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS order_price,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'swap_price'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') AS swap_price,
        if(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'success'),
 JSONExtractArrayRaw(JSONExtractString(event,
 'attributes')))[1],
 'value') = 'success',
 true,
 false) AS success
    FROM
    (
        SELECT *
        FROM spacebox.raw_block_results
        WHERE end_block_events ILIKE '%swap_transacted%' and height >= 15515000
    )
    WHERE JSONExtractString(event,
 'type') = 'swap_transacted'
);