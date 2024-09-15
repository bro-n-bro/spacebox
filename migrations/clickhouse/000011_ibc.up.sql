-- spacebox.ibc_msg_transfer definition

CREATE TABLE spacebox.ibc_msg_transfer
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `denom` String,
    `amount` Int256,
    `sender` String,
    `receiver` String
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 source_port,
 source_channel,
 sender,
 receiver)
SETTINGS index_granularity = 8192;

-- spacebox.ibc_msg_transfer_writer source

CREATE MATERIALIZED VIEW spacebox.ibc_msg_transfer_writer TO spacebox.ibc_msg_transfer
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `denom` String,
    `amount` String,
    `sender` String,
    `receiver` String
)
AS SELECT
    height,
    timestamp,
    txhash,
    JSONExtractString(msg,
 'sourcePort') AS source_port,
    JSONExtractString(msg,
 'sourceChannel') AS source_channel,
    JSONExtractString(msg,
 'token',
 'denom') AS denom,
    JSONExtractString(msg,
 'token',
 'amount') AS amount,
    JSONExtractString(msg,
 'sender') AS sender,
    JSONExtractString(msg,
 'receiver') AS receiver
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
    WHERE (type = '/ibc.applications.transfer.v1.MsgTransfer') AND (code = 0)
);

-- spacebox.ibc_msg_acknowledgement definition

CREATE TABLE spacebox.ibc_msg_acknowledgement
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `destination_port` String,
    `destination_channel` String,
    `data` String,
    `signer` String
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 source_port,
 source_channel,
 destination_port,
 destination_channel,
 signer)
SETTINGS index_granularity = 8192;


-- spacebox.ibc_msg_acknowledgement_writer source

CREATE MATERIALIZED VIEW spacebox.ibc_msg_acknowledgement_writer TO spacebox.ibc_msg_acknowledgement
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `destination_port` String,
    `destination_channel` String,
    `data` String,
    `signer` String
)
AS SELECT
    height,
    timestamp,
    txhash,
    JSONExtractString(msg,
 'packet',
 'sourcePort') AS source_port,
    JSONExtractString(msg,
 'packet',
 'sourceChannel') AS source_channel,
    JSONExtractString(msg,
 'packet',
 'destinationPort') AS destination_port,
    JSONExtractString(msg,
 'packet',
 'destinationChannel') AS destination_channel,
    base64Decode(JSONExtractString(msg,
 'packet',
 'data')) AS data,
    JSONExtractString(msg,
 'signer') AS signer
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
    WHERE (type = '/ibc.core.channel.v1.MsgAcknowledgement') AND (code = 0)
);


-- spacebox.ibc_msg_recv_packet definition

CREATE TABLE spacebox.ibc_msg_recv_packet
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `destination_port` String,
    `destination_channel` String,
    `data` String,
    `signer` String
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 source_port,
 source_channel,
 destination_port,
 destination_channel,
 signer)
SETTINGS index_granularity = 8192;


-- spacebox.ibc_msg_recv_packet_writer source

CREATE MATERIALIZED VIEW spacebox.ibc_msg_recv_packet_writer TO spacebox.ibc_msg_recv_packet
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `destination_port` String,
    `destination_channel` String,
    `data` String,
    `signer` String
)
AS SELECT
    height,
    timestamp,
    txhash,
    JSONExtractString(msg,
 'packet',
 'sourcePort') AS source_port,
    JSONExtractString(msg,
 'packet',
 'sourceChannel') AS source_channel,
    JSONExtractString(msg,
 'packet',
 'destinationPort') AS destination_port,
    JSONExtractString(msg,
 'packet',
 'destinationChannel') AS destination_channel,
    base64Decode(JSONExtractString(msg,
 'packet',
 'data')) AS data,
    JSONExtractString(msg,
 'signer') AS signer
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
    WHERE (type = '/ibc.core.channel.v1.MsgRecvPacket') AND (code = 0)
);