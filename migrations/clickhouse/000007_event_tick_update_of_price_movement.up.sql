CREATE TABLE spacebox.dex_message_event_tick_update_of_price_movement
(
    `timestamp` DateTime,
    `height` Int64,
    `TokenZero` String,
    `TokenOne` String,
    `TickIndex` Int64,
    `price` Float64
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 TokenZero,
 TokenOne,
 TickIndex,
 price)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.dex_message_event_tick_update_of_price_movement_writer TO spacebox.dex_message_event_tick_update_of_price_movement (
  `timestamp` DateTime, `height` Int64,
  `TokenZero` String, `TokenOne` String,
  `TickIndex` Int64, `price` Float64
) AS WITH raw_message_with_index AS (
  SELECT
    timestamp,
    height,
    txhash,
    msg,
    msg_index,
    msg_type,
    events,
    signer
  FROM
    spacebox.raw_transaction ARRAY
    JOIN JSONExtractArrayRaw(tx, 'body', 'messages') AS msg,
    arrayMap(
      x -> JSONExtractString(x, '@type'),
      JSONExtractArrayRaw(tx, 'body', 'messages')
    ) AS msg_type,
    arrayEnumerate(
      JSONExtractArrayRaw(tx, 'body', 'messages')
    ) AS msg_index
  WHERE
    code = 0
),
raw_message_event_with_index AS (
  SELECT
    timestamp,
    height,
    txhash,
    msg,
    msg_index,
    msg_type,
    type,
    attributes,
    event_index,
    signer
  FROM
    raw_message_with_index ARRAY
    JOIN arrayMap(
      x -> JSONExtractString(x, 'type'),
      arrayFilter(
        x1 -> (
          (
            toUInt32OrNull(
              JSONExtractString(
                arrayFirst(
                  x2 -> (
                    JSONExtractString(x2, 'key') = 'msg_index'
                  ),
                  JSONExtractArrayRaw(x1, 'attributes')
                ),
                'value'
              )
            ) + 1
          ) = msg_index
        ),
        JSONExtractArrayRaw(events)
      )
    ) AS type,
    arrayMap(
      x -> JSONExtractString(x, 'attributes'),
      arrayFilter(
        x1 -> (
          (
            toUInt32OrNull(
              JSONExtractString(
                arrayFirst(
                  x2 -> (
                    JSONExtractString(x2, 'key') = 'msg_index'
                  ),
                  JSONExtractArrayRaw(x1, 'attributes')
                ),
                'value'
              )
            ) + 1
          ) = msg_index
        ),
        JSONExtractArrayRaw(events)
      )
    ) AS attributes,
    arrayEnumerate(
      arrayFilter(
        x1 -> (
          (
            toUInt32OrNull(
              JSONExtractString(
                arrayFirst(
                  x2 -> (
                    JSONExtractString(x2, 'key') = 'msg_index'
                  ),
                  JSONExtractArrayRaw(x1, 'attributes')
                ),
                'value'
              )
            ) + 1
          ) = msg_index
        ),
        JSONExtractArrayRaw(events)
      )
    ) AS event_index
),
dex_message_event AS (
  SELECT
    timestamp,
    height,
    txhash,
    msg,
    msg_index,
    msg_type,
    type,
    attributes,
    event_index,
    JSONExtractString(
      arrayFilter(
        x -> (
          JSONExtractString(x, 'key') = 'action'
        ),
        JSONExtractArrayRaw(attributes)
      ) [1],
      'value'
    ) AS action,
    signer
  FROM
    raw_message_event_with_index
  WHERE
    JSONExtractString(
      arrayFilter(
        x -> (
          JSONExtractString(x, 'key') = 'module'
        ),
        JSONExtractArrayRaw(attributes)
      ) [1],
      'value'
    ) = 'dex'
),
dex_message_event_tick_update AS (
  SELECT
    *
  FROM
    dex_message_event
  WHERE
    action = 'TickUpdate'
)
SELECT
  timestamp,
  height,
  JSONExtractString(
    arrayFilter(
      x -> (
        JSONExtractString(x, 'key') = 'TokenZero'
      ),
      JSONExtractArrayRaw(attributes)
    ) [1],
    'value'
  ) AS TokenZero,
  JSONExtractString(
    arrayFilter(
      x -> (
        JSONExtractString(x, 'key') = 'TokenOne'
      ),
      JSONExtractArrayRaw(attributes)
    ) [1],
    'value'
  ) AS TokenOne,
  toInt64(
    JSONExtractString(
      arrayFilter(
        x -> (
          JSONExtractString(x, 'key') = 'TickIndex'
        ),
        JSONExtractArrayRaw(attributes)
      ) [1],
      'value'
    )
  ) AS TickIndex,
  pow(1.0001, TickIndex) AS price
FROM
  dex_message_event_tick_update
WHERE
  (
    msg_type = '/neutron.dex.MsgPlaceLimitOrder'
  )
  AND (
    JSONExtractString(msg, 'tokenOut') = JSONExtractString(
      arrayFilter(
        x -> (
          JSONExtractString(x, 'key') = 'TokenIn'
        ),
        JSONExtractArrayRaw(attributes)
      ) [1],
      'value'
    )
  );
