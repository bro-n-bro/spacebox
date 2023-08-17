-- 000055_swap.up.sql
CREATE TABLE IF NOT EXISTS spacebox.swap_topic
(
    `height`                       Int64,
    `msg_index`                    UInt32,
    `batch_index`                  UInt32,
    `pool_id`                      UInt32,
    `swap_requester`               String,
    `offer_coin_denom`             String,
    `offer_coin_amount`            Float64,
    `demand_coin_denom`            String,
    `exchanged_demand_coin_amount` Float64,
    `transacted_coin_amount`       Float64,
    `remaining_offer_coin_amount`  Float64,
    `offer_coin_fee_amount`        Float64,
    `order_expiry_height`          Int64,
    `exchanged_coin_fee_amount`    Float64,
    `order_price`                  Float64,
    `swap_price`                   Float64,
    `success`                      BOOL
) ENGINE = Kafka('kafka:9093', 'swap', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.swap
(
    `height`                       Int64,
    `msg_index`                    UInt32,
    `batch_index`                  UInt32,
    `pool_id`                      UInt32,
    `swap_requester`               String,
    `offer_coin_denom`             String,
    `offer_coin_amount`            Float64,
    `demand_coin_denom`            String,
    `exchanged_demand_coin_amount` Float64,
    `transacted_coin_amount`       Float64,
    `remaining_offer_coin_amount`  Float64,
    `offer_coin_fee_amount`        Float64,
    `order_expiry_height`          Int64,
    `exchanged_coin_fee_amount`    Float64,
    `order_price`                  Float64,
    `swap_price`                   Float64,
    `success`                      BOOL
) ENGINE = ReplacingMergeTree()
      ORDER BY (`pool_id`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS swap_consumer TO spacebox.swap
AS
SELECT height,
       msg_index,
       batch_index,
       pool_id,
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
FROM spacebox.swap_topic
GROUP BY height, msg_index, batch_index, pool_id, swap_requester, offer_coin_denom, offer_coin_amount,
         demand_coin_denom, exchanged_demand_coin_amount, transacted_coin_amount, remaining_offer_coin_amount,
         offer_coin_fee_amount, order_expiry_height, exchanged_coin_fee_amount, order_price, swap_price, success;
