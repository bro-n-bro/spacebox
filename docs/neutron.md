# Neutron

## Tables

### `raw_block`

In this table, the network blocks are presented as received from gRPC. The data in this table is suitable for monitoring overall network activity as well as for building more customized queries and tables.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L33)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L17)


---

### `raw_block_results`

This table stores the results of network blocks as processed by the chain. It includes data on transactions, events at the beginning and end of blocks, updates to validators, and consensus parameter changes. It is primarily useful for monitoring network state transitions and historical block data analysis.


- **Fields:**
  - **height** (`Int64`): The block height for which these results apply.
  - **txs_results** (`String`): The results of the transactions included in the block, stored as a string.
  - **begin_block_events** (`String`): Events that occurred at the start of the block.
  - **end_block_events** (`String`): Events that occurred at the end of the block.
  - **validator_updates** (`String`): Updates to validator set during the block processing.
  - **consensus_param_updates** (`String`): Updates to consensus parameters.
  - **timestamp** (`DATETIME`): The timestamp when the block was processed.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L88)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L60)
---

### `raw_transaction`

This table captures detailed data about transactions on the blockchain, including information on gas usage, transaction status, and related events. It serves as a primary source for analyzing transaction-level data.
- **Fields:**
  - **timestamp** (`DATETIME`): The timestamp when the transaction occurred.
  - **height** (`Int64`): The block height at which the transaction was included.
  - **txhash** (`String`): The unique hash identifier of the transaction.
  - **codespace** (`String`): The module or component that generated an error, if applicable.
  - **code** (`Int64`): The status code indicating success or failure of the transaction.
  - **raw_log** (`String`): The raw log output of the transaction.
  - **logs** (`String`): Detailed logs of the transaction.
  - **info** (`String`): Additional information about the transaction, if available.
  - **gas_wanted** (`Int64`): The amount of gas requested for the transaction.
  - **gas_used** (`Int64`): The actual amount of gas consumed by the transaction.
  - **tx** (`String`): The transaction data in string format.
  - **events** (`String`): Events triggered by the transaction.
  - **signer** (`String`): The address of the signer of the transaction.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L126)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L101)

---

### `raw_genesis`

This table contains data related to the genesis block of the chain, including the initial state, chain configuration, and parameters.
- **Fields:**
  - **genesis_time** (`DATETIME`): The time at which the genesis block was created.
  - **chain_id** (`String`): The unique identifier for the blockchain network.
  - **initial_height** (`Int64`): The initial block height of the chain.
  - **consensus_params** (`String`): Parameters related to consensus algorithms and protocols.
  - **app_hash** (`String`): The hash representing the application state at genesis.
  - **app_state** (`String`): The application state data at the genesis block.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L172)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L157)

---

### `txs_events`

This table stores transaction event data captured from blockchain operations. It is structured for efficient querying and tracking of event types and their associated attributes at a particular block height.

- **Fields:**
  - `height` (Int64): The block height where the event occurred.
  - `type` (String): The event type, representing different categories of blockchain events.
  - `attributes` (String): A JSON-encoded string containing additional data or metadata associated with the event.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000002_events.up.sql#L14)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000002_events.up.sql#L1)
---

### `wasm_txs_events`

This table captures events specifically related to WebAssembly (WASM) transactions on the blockchain. It contains comprehensive data for tracking transaction metadata, including contract interactions.

- **Fields:**
  - `timestamp` (DateTime): The timestamp of the transaction.
  - `height` (Int64): The block height where the transaction occurred.
  - `txhash` (String): The hash of the transaction.
  - `signer` (String): The address of the transaction signer.
  - `contract_address` (String): The address of the involved smart contract.
  - `action` (String): The specific action associated with the transaction.
  - `attributes` (String): JSON-encoded attributes that provide further details.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L57)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000001_raw.up.sql#L36)

---

### `genesis_balances`

This table stores initial balances from the genesis state of the blockchain. It tracks the distribution of coins across addresses at the initial state.

- **Fields:**
  - `height` (Int64): The block height, set to 0 for genesis data.
  - `type` (String): The type of event, representing coin distribution (`coin_received`).
  - `address` (String): The blockchain address holding the balance.
  - `coins` (String): JSON-encoded string representing coins held.
  - `amount` (Int64): The numeric value of the coins.
  - `denom` (String): The denomination or type of coins.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000003_genesis_balances.up.sql#L20)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000003_genesis_balances.up.sql#L5)
---


### `dex_message_event_tick_update`

This table stores tick update events related to DEX messages. It tracks changes to orders on the DEX using characteristics such as tick index and tranche key.
- **Fields:**
  - **timestamp** (DateTime): Timestamp of the event.
  - **height** (Int64): Block height associated with the event.
  - **txhash** (String): Transaction hash.
  - **attributes** (String): Raw attributes of the event in JSON format.
  - **signer** (String): Transaction signer.
  - **TokenZero** (String): First token in the trading pair.
  - **TokenOne** (String): Second token in the trading pair.
  - **TokenIn** (String): Token involved in the trade.
  - **TickIndex** (Int32): Tick index for this event.
  - **TrancheKey** (String): Liquidity tranche key.
  - **Fee** (UInt16): Fee associated with the event.
  - **Reserves** (Int256): Reserves impacting the order state.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000004_dex_message_event_tick_update.up.sql#L29)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000004_dex_message_event_tick_update.up.sql#L1)

---

### `debs_and_creds`

This table stores information on credits and debits occurring on the blockchain. It tracks token movements between addresses and provides insights into financial activity.
- **Fields:**
  - **height** (Int64): Block height associated with the movement.
  - **type** (String): Event type (e.g., credit or debit).
  - **address** (String): Address involved in the transaction.
  - **coins** (String): Coin data as a string representation.
  - **amount** (Int64): Amount of coins transacted.
  - **denom** (String): Denomination of the coins.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000005_debs_and_creds.up.sql#L22)
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000005_debs_and_creds.up.sql#L71)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000005_debs_and_creds.up.sql#L5)

---

### `wasm_swaps`

This table stores data related to swap events from WASM contracts on the blockchain.
- **Fields:**
  - **height** (Int64): Block height associated with the swap.
  - **contract_address** (String): Address of the contract executing the swap.
  - **action** (String): Action type, usually 'swap'.
  - **ask_asset** (String): Asset being requested.
  - **commission_amount** (Int128): Commission fee associated with the swap.
  - **maker_fee_amount** (Int128): Maker fee amount for the swap.
  - **offer_amount** (Int128): Amount being offered in the swap.
  - **offer_asset** (String): Asset being offered.
  - **receiver** (String): Receiving address.
  - **return_amount** (Int128): Amount returned to the initiator.
  - **sender** (String): Address initiating the swap.
  - **spread_amount** (Int128): Spread amount for the swap.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000006_wasm.up.sql#L31)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000006_wasm.up.sql#L5)
---


### `wasm_votes`

This table stores data related to votes in WASM contracts on the blockchain.
- **Fields:**
  - **height** (Int64): Block height associated with the vote.
  - **contract_address** (String): Address of the contract managing the vote.
  - **action** (String): Action type, usually 'vote'.
  - **sender** (String): Address of the voter.
  - **proposal_id** (Int64): ID of the proposal being voted on.
  - **position** (String): Position of the voter (e.g., 'yes' or 'no').
  - **status** (String): Status of the vote.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000006_wasm.up.sql#L130)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000006_wasm.up.sql#L110)

---

### `message`

This table stores messages processed from transactions, including their associated metadata. It allows for monitoring and querying message-level details such as type, signer, and content.
- **Fields:**
  - **timestamp** (DateTime): Timestamp when the message was processed.
  - **height** (Int64): The block height associated with the message.
  - **txhash** (String): Hash of the transaction containing the message.
  - **type** (String): The type of the message (e.g., `MsgSend`, `MsgGrant`).
  - **signer** (String): The address that signed the transaction.
  - **message** (String): The message content in raw JSON format.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000008_message.up.sql#L24)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000008_message.up.sql#L5)

---

### `authz_msg_grant`

This table tracks the granting of authorizations within the blockchain, capturing data related to the granter, grantee, and type of authorization.
- **Fields:**
  - **timestamp** (DateTime): The time when the grant was recorded.
  - **height** (Int64): Block height associated with the grant.
  - **txhash** (String): Transaction hash that contains the grant event.
  - **granter** (String): Address granting the authorization.
  - **grantee** (String): Address receiving the authorization.
  - **authorization** (String): Type of authorization granted, extracted as JSON.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000009_authz.up.sql#L19)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000009_authz.up.sql#L1)

---

### `authz_msg_revoke`

This table captures revocation events for authorizations between addresses, tracking who revoked, whom they revoked, and the specific message type.
- **Fields:**
  - **timestamp** (DateTime): The time the revocation was recorded.
  - **height** (Int64): Block height of the revocation event.
  - **txhash** (String): Transaction hash containing the revocation.
  - **granter** (String): Address revoking the authorization.
  - **grantee** (String): Address whose authorization is being revoked.
  - **msg_type_url** (String): Type of message being revoked.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000009_authz.up.sql#L63)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000009_authz.up.sql#L45)

---

### `interchain_account`

This table stores details related to interchain accounts, including registration events and their associated metadata.
- **Fields:**
  - **timestamp** (DateTime): The time of account registration.
  - **height** (Int32): Block height for the event.
  - **txhash** (String): Hash of the transaction containing the event.
  - **owner** (String): Owner of the interchain account.
  - **connection_id** (String): IBC connection ID used for the account.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000010_interchaintx.up.sql#L16)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000010_interchaintx.up.sql#L1)

---

### `feegrant_msg_allowance`

This table captures data related to fee grants, such as granters and grantees involved in fee allowance events.
- **Fields:**
  - **timestamp** (DateTime): The time the fee allowance event was recorded.
  - **height** (Int64): The block height at which the event took place.
  - **txhash** (String): Transaction hash of the event.
  - **granter** (String): Address granting the allowance.
  - **grantee** (String): Address receiving the fee allowance.
  - **allowance** (String): Details of the granted allowance in raw JSON format.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000011_feegrant.up.sql#L19)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000011_feegrant.up.sql#L1)

---

### `ibc_msg_transfer`

This table records inter-blockchain communication (IBC) transfer events, capturing details about the sender, receiver, amount, and other transfer parameters.
- **Fields:**
  - **timestamp** (DateTime): Time when the IBC transfer occurred.
  - **height** (Int64): Block height of the transfer.
  - **txhash** (String): Transaction hash containing the transfer.
  - **source_port** (String): Source port involved in the transfer.
  - **source_channel** (String): Source channel involved in the transfer.
  - **denom** (String): Denomination of the transferred token.
  - **amount** (Int64): Amount of tokens transferred.
  - **sender** (String): Address sending the tokens.
  - **receiver** (String): Address receiving the tokens.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000012_ibc.up.sql#L23)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000012_ibc.up.sql#L1)

---

### `ibc_msg_acknowledgement`

This table stores data regarding acknowledgments of IBC messages.
- **Fields:**
  - **timestamp** (DateTime): The time the acknowledgment was recorded.
  - **height** (Int64): Block height of the acknowledgment.
  - **txhash** (String): Transaction hash containing the acknowledgment.
  - **source_port** (String): Source port of the packet being acknowledged.
  - **source_channel** (String): Source channel of the packet.
  - **destination_port** (String): Destination port of the packet.
  - **destination_channel** (String): Destination channel of the packet.
  - **data** (String): Acknowledged data in decoded format.
  - **signer** (String): Address acknowledging the packet.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000012_ibc.up.sql#L76)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000012_ibc.up.sql#L53)

---

### `ibc_msg_recv_packet`

This table captures data about received IBC packets, with details about the packet transfer and signers.
- **Fields:**
  - **timestamp** (DateTime): The time when the packet was received.
  - **height** (Int64): Block height for the packet reception.
  - **txhash** (String): Hash of the transaction containing the packet reception.
  - **source_port** (String): Source port of the packet.
  - **source_channel** (String): Source channel of the packet.
  - **destination_port** (String): Destination port of the packet.
  - **destination_channel** (String): Destination channel of the packet.
  - **data** (String): Data of the packet in decoded format.
  - **signer** (String): Address that received the packet.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000012_ibc.up.sql#L129)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000012_ibc.up.sql#L106)

---

### `account`

This table tracks account information based on blockchain transactions.
- **Fields:**
  - **address** (String): Address of the account.
  - **height** (Int32): Block height of the transaction affecting the account.
  - **timestamp** (DateTime): Time when the account-related transaction occurred.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000013_account.up.sql#L10)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000013_account.up.sql#L1)

---

### `liveness`

This table stores information related to network liveness, specifically capturing data on missed blocks. It is primarily used for monitoring validator activity, helping to identify liveness issues in the network.
- **Fields:**
  - **height** (`Int32`): Block height at which the event occurred.
  - **timestamp** (`DateTime`): The timestamp when the event was recorded.
  - **address** (`String`): Address of the entity related to the liveness event.
  - **missed_blocks** (`Int32`): Number of blocks missed by the entity.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000014_liveness.up.sql#L14)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000014_liveness.up.sql#L1)

---

### `interchainqueries`

This table captures interchain query data, which is crucial for understanding cross-chain interactions and querying logic across connected networks.
- **Fields:**
  - **timestamp** (`DateTime`): The timestamp when the transaction was processed.
  - **height** (`Int32`): The block height of the transaction.
  - **txhash** (`String`): Transaction hash.
  - **action** (`String`): The action performed by the query.
  - **query_id** (`Int32`): Unique identifier for the query.
  - **connection_id** (`String`): The ID of the connection used.
  - **owner** (`String`): The owner of the query.
  - **type** (`String`): The type of interchain query.
  - **kv_key** (`String`): The key used in key-value operations for the query.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000015_interchainqueries.up.sql#L20)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000015_interchainqueries.up.sql#L1)
---

### `feerefunder_lock_fees`

This table holds data related to fee-refunding operations triggered by locking fees on the network.
- **Fields:**
  - **timestamp** (`DateTime`): The timestamp of the transaction.
  - **height** (`Int32`): The block height of the transaction.
  - **txhash** (`String`): Transaction hash.
  - **channel_id** (`String`): ID of the channel related to the fee lock.
  - **payer** (`String`): The entity responsible for payment.
  - **port_id** (`String`): The port identifier.
  - **sequence** (`Int32`): The sequence number of the transaction.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000016_feerefunder.up.sql#L18)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000016_feerefunder.up.sql#L1)
---

### `feerefunder_distribute_ack_fee`

This table logs data concerning the distribution of acknowledgement fees.
- **Fields:**
  - **timestamp** (`DateTime`): The timestamp when the transaction occurred.
  - **height** (`Int32`): The block height of the transaction.
  - **txhash** (`String`): Transaction hash.
  - **channel_id** (`String`): ID of the channel associated with the fee distribution.
  - **receiver** (`String`): Receiver of the acknowledgement fee.
  - **port_id** (`String`): The port identifier.
  - **sequence** (`Int32`): The sequence number for the transaction.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000016_feerefunder.up.sql#L58)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000016_feerefunder.up.sql#L41)
---

### `feerefunder_distribute_timeout_fee`

This table logs the distribution of fees in the event of timeouts.
- **Fields:**
  - **timestamp** (`DateTime`): Timestamp of the transaction.
  - **height** (`Int32`): The block height of the transaction.
  - **txhash** (`String`): Transaction hash.
  - **channel_id** (`String`): Channel ID associated with the fee distribution.
  - **receiver** (`String`): Recipient of the timeout fee.
  - **port_id** (`String`): The port identifier.
  - **sequence** (`Int32`): The transaction sequence number.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000016_feerefunder.up.sql#L96)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000016_feerefunder.up.sql#L79)
---

### `admin_module`

The `admin_module` table captures data related to the administration module's operations.
- **Fields:**
  - **timestamp** (`DateTime`): The timestamp of the transaction.
  - **height** (`Int32`): The block height.
  - **txhash** (`String`): Transaction hash.
  - **type** (`String`): Type of operation or message.
  - **value** (`String`): The value associated with the transaction or operation.
- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000017_admin_module.up.sql#L17)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000017_admin_module.up.sql#L1)
---

### `sdk_auction`

This table stores data related to auction activities conducted via the SDK auction module.
- **Fields:**
  - **timestamp** (`DateTime`): Timestamp when the auction transaction occurred.
  - **height** (`Int32`): The block height of the transaction.
  - **txhash** (`String`): Transaction hash.
  - **bidder** (`String`): The address of the bidder.
  - **denom** (`String`): The denomination of the bid amount.
  - **amount** (`Int64`): The amount of the bid.
  - **transactions** (`Array(String)`): List of associated transactions.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000018_sdk_auction.up.sql#L19)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000018_sdk_auction.up.sql#L1)

---

### `spacebox.dex_message_event_tick_update_of_price_movement`

This table captures data regarding updates to tick-based price movements in decentralized exchange (DEX) message events. The data stored here reflects updates that are processed within the context of DEX-related transactions.
- **Fields:**
  - **timestamp** (`DateTime`): The time when the tick update event occurred.
  - **height** (`Int64`): The block height corresponding to the transaction.
  - **TokenZero** (`String`): The identifier of the first token in the trade pair.
  - **TokenOne** (`String`): The identifier of the second token in the trade pair.
  - **TickIndex** (`Int64`): An index representing the price level or tick.
  - **price** (`Float64`): The price derived from the tick index using the formula `pow(1.0001, TickIndex)`.

- [Writing source](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000007_event_tick_update_of_price_movement.up.sql#L20)
- [Table definition](https://github.com/bro-n-bro/spacebox/blob/neutron/migrations/clickhouse/000007_event_tick_update_of_price_movement.up.sql#L1)
