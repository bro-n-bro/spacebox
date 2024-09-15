-- spacebox.message_create_route definition

CREATE TABLE spacebox.message_create_route
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source` String,
    `destination` String,
    `name` String
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 source,
 destination,
 name)
SETTINGS index_granularity = 8192;


-- spacebox.message_create_route_writer source

CREATE MATERIALIZED VIEW spacebox.message_create_route_writer TO spacebox.message_create_route
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source` String,
    `destination` String,
    `name` String
)
AS SELECT
    timestamp,
    height,
    txhash,
    JSONExtractString(msg,
 'source') AS source,
    JSONExtractString(msg,
 'destination') AS destination,
    JSONExtractString(msg,
 'name') AS name
FROM
(
    SELECT
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx,
 'body',
 'messages'))) AS msg,
        JSONExtractString(msg,
 '@type') AS type
    FROM spacebox.raw_transaction
    WHERE (type = '/cyber.grid.v1beta1.MsgCreateRoute') AND (code = 0)
);

-- spacebox.message_edit_route definition

CREATE TABLE spacebox.message_edit_route
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source` String,
    `destination` String,
    `denom` String,
    `amount` Int256
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 source,
 destination)
SETTINGS index_granularity = 8192;

-- spacebox.message_edit_route_writer source

CREATE MATERIALIZED VIEW spacebox.message_edit_route_writer TO spacebox.message_edit_route
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source` String,
    `destination` String,
    `denom` String,
    `amount` String
)
AS SELECT
    timestamp,
    height,
    txhash,
    JSONExtractString(msg,
 'source') AS source,
    JSONExtractString(msg,
 'destination') AS destination,
    JSONExtractString(msg,
 'value',
 'denom') AS denom,
    JSONExtractString(msg,
 'value',
 'amount') AS amount
FROM
(
    SELECT
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx,
 'body',
 'messages'))) AS msg,
        JSONExtractString(msg,
 '@type') AS type
    FROM spacebox.raw_transaction
    WHERE (type = '/cyber.grid.v1beta1.MsgEditRoute') AND (code = 0)
);

-- spacebox.message_delete_route definition

CREATE TABLE spacebox.message_delete_route
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source` String,
    `destination` String
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 source,
 destination)
SETTINGS index_granularity = 8192;


-- spacebox.message_delete_route_writer source

CREATE MATERIALIZED VIEW spacebox.message_delete_route_writer TO spacebox.message_delete_route
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source` String,
    `destination` String
)
AS SELECT
    timestamp,
    height,
    txhash,
    JSONExtractString(msg,
 'source') AS source,
    JSONExtractString(msg,
 'destination') AS destination
FROM
(
    SELECT
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx,
 'body',
 'messages'))) AS msg,
        JSONExtractString(msg,
 '@type') AS type
    FROM spacebox.raw_transaction
    WHERE (type = '/cyber.grid.v1beta1.MsgDeleteRoute') AND (code = 0)
);