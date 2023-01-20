#!/bin/bash

set -e
cd $(dirname $0)

topics=("account" "account_balance" "annual_provision" "block" "community_pool" "distribution_params" "delegation_reward"
  "delegation_reward_message" "delegation" "delegation_message" "gov_params" "message" "mint_params" "multisend_message"
  "proposal" "proposal_vote_message" "proposal_tally_result" "proposal_deposit" "proposal_deposit_message" "redelegation"
  "redelegation_message" "send_message" "staking_params" "staking_pool" "supply" "tx" "unbonding_delegation"
  "unbonding_delegation_message" "validator_info" "validator_status" "validator")


for i in 1 2 3 4 5; do
  echo "attempt: $i" &&
    for topic in ${topics[@]}; do
      kafka-topics.sh --create --topic $topic --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server kafka:9093
    done && break || sleep 1
done
#
#for i in 1 2 3 4 5; do
#  echo "attempt: $i" &&
#      echo $topics | xargs -I % -L1 kafka-topics.sh --create --topic % --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server kafka:9093 && break || sleep 1
#done

#
#
#for i in 1 2 3 4 5; do
#  echo "attempt: $i" &&
#    for topic in ${topics[@]}; do
#      kafka-topics.sh --bootstrap-server kafka:9093 --if-exists --alter --topic $topic --partitions 2
#    done && break || sleep 10
#done
