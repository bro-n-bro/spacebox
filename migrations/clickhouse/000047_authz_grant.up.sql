-- 000047_authz_grant.up.sql
CREATE TABLE IF NOT EXISTS spacebox.authz_grant_topic
(
    `height`          Int64,
    `granter_address` String,
    `grantee_address` String,
    `msg_type`        String,
    `expiration`      String
) ENGINE = Kafka('kafka:9093', 'authz_grant', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.authz_grant
(
    `height`          Int64,
    `granter_address` String,
    `grantee_address` String,
    `msg_type`        String,
    `expiration`      TIMESTAMP

) ENGINE = ReplacingMergeTree()
      ORDER BY (`grantee_address`, `granter_address`, `msg_type`);


CREATE MATERIALIZED VIEW IF NOT EXISTS authz_grant_consumer TO spacebox.authz_grant
AS
SELECT height, granter_address, grantee_address, msg_type, parseDateTimeBestEffortOrZero(expiration) as expiration
FROM spacebox.authz_grant_topic
GROUP BY height, granter_address, grantee_address, msg_type, expiration;


