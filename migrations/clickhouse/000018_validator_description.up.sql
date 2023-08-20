-- 000018_validator_description.up.sql
CREATE TABLE IF NOT EXISTS spacebox.validator_description_topic
(
    `operator_address`  String,
    `moniker`           String,
    `identity`          String,
    `website`           String,
    `security_contact`  String,
    `details`           String,
    `height`            Int64
) ENGINE = Kafka('kafka:9093', 'validator_description', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.validator_description
(
    `operator_address`  String,
    `moniker`           String,
    `identity`          String,
    `website`           String,
    `security_contact`  String,
    `details`           String,
    `height`            Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS validator_description_consumer TO spacebox.validator_description
AS
SELECT operator_address, moniker, identity, website, security_contact, details, height
FROM spacebox.validator_description_topic
GROUP BY operator_address, moniker, identity, website, security_contact, details, height;

