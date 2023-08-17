-- 000014_proposal_tally_result.up.sql
CREATE TABLE IF NOT EXISTS spacebox.proposal_tally_result_topic
(
    `proposal_id`  Int64,
    `yes`          Int64,
    `abstain`      Int64,
    `no`           Int64,
    `no_with_veto` Int64,
    `height`       Int64
) ENGINE = Kafka('kafka:9093', 'proposal_tally_result', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.proposal_tally_result
(
    `proposal_id`  Int64,
    `yes`          Int64,
    `abstain`      Int64,
    `no`           Int64,
    `no_with_veto` Int64,
    `height`       Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`proposal_id`);

CREATE MATERIALIZED VIEW IF NOT EXISTS proposal_tally_result_consumer TO spacebox.proposal_tally_result
AS
SELECT proposal_id, yes, abstain, no, no_with_veto, height
FROM spacebox.proposal_tally_result_topic
GROUP BY proposal_id, yes, abstain, no, no_with_veto, height;

