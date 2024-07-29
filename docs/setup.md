# Setup

## Requirements

To operate the Spacebox you'll need an x86-64/arm machine with >8GB of RAM, and >4 CPU cores. For storage it is better to use faster SSD or NVME-like drives, size depends on the chain and TX volume(cosmoshub-4 index utilizes ~1 TB). Spacebox runs in [Docker](https://docs.docker.com/engine/install/) with help of[Docker-compose](https://docs.docker.com/compose/install/). Also, you will need the RPC and GRPC endpoints of the chain, which you will index with the appropriate historical state.

## Quick start

### Get

Clone the [Spacebox](https://github.com/bro-n-bro/spacebox.git) repo, it contains everything to get started.

`console`

```console
$ git clone https://github.com/bro-n-bro/spacebox.git
Cloning into 'spacebox'...
remote: Enumerating objects: 1111, done.
remote: Counting objects: 100% (59/59), done.
remote: Compressing objects: 100% (41/41), done.
remote: Total 1111 (delta 17), reused 23 (delta 16), pack-reused 1052
Receiving objects: 100% (1111/1111), 2.82 MiB | 10.48 MiB/s, done.
Resolving deltas: 100% (601/601), done.
$ ls spacebox/
config  docker-compose-local.yaml  docker-compose.yaml  docs  go.mod  LICENSE  migrations  mkdocs.yml  README.md
```

### Set

Fill .env with chain settings like chain prefix, node RPC & GRPC, and start \ stop height:

`.env`

```bash
START_HEIGHT=5048767  # Start block height
STOP_HEIGHT=0 # Stop block height, 0 for actual height
WORKERS_COUNT=15 # Go workers to pull data in async mode
SUBSCRIBE_NEW_BLOCKS=true # pull actual blocks


# Chain settings
CHAIN_PREFIX=cosmos # Prefix of indexing chain
WS_ENABLED=true # Websocket enabled
RPC_URL=http://0.0.0.0:26657 # RPC API
GRPC_URL=0.0.0.0:9090 # GRPC API, no HTTP\S prefix
GRPC_SECURE_CONNECTION=false # GRPC secure connection
```

### Launch

When `.env` is filled to start all containers run:

`console`

```bash
$ docker-compose up -d
Creating network "spacebox_default" with the default driver
Creating spacebox_hasura_1         ... done
Creating spacebox_mongo-crawler_1  ... done
Creating spacebox_ndc-clickhouse_1 ... done
Creating spacebox_clickhouse_1     ... done
Creating spacebox-zookeeper        ... done
Creating spacebox_postgres_1       ... done
Creating spacebox_kafka_1          ... done
Creating spacebox-kafka-ui         ... done
Creating spacebox_migration_1      ... done
```

If everything is set correctly you will see the following in `spacebox_crawler_1`:

`console`

```console
$ docker logs spacebox_crawler_1 -f 
INF starting app cmp=app version=v1.2.0
INF module registered cmp=app name=raw version=v1.2.0
INF all modules registered cmp=app count=1 version=v1.2.0
INF starting cmp=app service=storage version=v1.2.0
INF started cmp=app service=storage version=v1.2.0
INF starting cmp=app service=grpc_client version=v1.2.0
INF started cmp=app service=grpc_client version=v1.2.0
INF starting cmp=app service=rpc_client version=v1.2.0
INF started cmp=app service=rpc_client version=v1.2.0
INF starting cmp=app service=broker version=v1.2.0
INF started cmp=app service=broker version=v1.2.0
INF starting cmp=app service=worker version=v1.2.0
INF started cmp=app service=worker version=v1.2.0
INF starting cmp=app service=server version=v1.2.0
INF listening for new block events cmp=worker version=v1.2.0
INF started cmp=app service=server version=v1.2.0
INF starting cmp=app service=health_checker version=v1.2.0
INF exit not needed cmp=worker version=v1.2.0
INF started cmp=app service=health_checker version=v1.2.0
INF start metrics scraper cmp=server version=v1.2.0
INF application started cmp=app version=v1.2.0
INF parse block cmp=worker height=1 version=v1.2.0 worker_number=1
INF parse block cmp=worker height=2 version=v1.2.0 worker_number=11
INF parse block cmp=worker height=4 version=v1.2.0 worker_number=19
INF parse block cmp=worker height=5 version=v1.2.0 worker_number=17
INF parse block cmp=worker height=3 version=v1.2.0 worker_number=6
```

To stop and remove all containers use the following:

`console`

```bash
docker-compose down
```

### Issues?

If after `docker-compose up` you see the error:

`console`

```console
ERROR: for crawler  Container "d0d8ccc463b8" is unhealthy.
ERROR: Encountered errors while bringing up the project.
```

Then it is necessary to grant the ownership of the `volumes` folder to the docker user (uid 1001):

`console`

```console
$ docker-compose down
$ chown -R 1001:1001 volumes/
$ docker-compose up -d
```

It usually requires around ~2 minutes to start everything. Check the log of each container with `docker logs <container_name>` to see what's going under the hood. It is possible to adjust some parameters on the fly, edit `.env`, and restart the appropriate container.

## Upgrading

Spacebox main part [spacebox-crawler](https://github.com/bro-n-bro/spacebox-crawler/releases) follows [semantic versioning:](https://semver.org/) `MAJOR.MINOR.PATCH` + some releases are chain-specific and contain chain name in the tag, e.g. `v2.0.0-neutron`.

As long as spacebox is considered as a beta software, every major version upgrade will require re-sync, check the release details for more info on that.

We recommend using a specified version for the crawler in `docker-compose.yml`, instead of `:latest` that will ease troubleshooting and upgrades:

`docker-compose.yaml`

```console
version: "3.9"

services:
 crawler:
 image: bronbro/spacebox-crawler:v1.2.0
```

For upgrade with full resync stop everything remove the volmes folder and start over with the newer version of the crawler:

`console`

```console
$ docker-compose down
$ rm -rf  volumes/
$ docker-compose up -d
```

If an upgrade is happening alongside the chain upgrade, then it is possible to relaunch only the crawler:

`console`

```bash
$ docker stop spacebox_crawler-1
$ docker rm spacebox_crawler-1
```

Set new version in `docker-compose.yaml`

```diff
services:
 crawler:
-    image: bronbro/spacebox-crawler:v1.2.0
+    image: bronbro/spacebox-crawler:v1.3.0
```

Start crawler container

`console`

```bash
docker-compose up -d crawler
```

In such case, indexation with the new version will start since the block you will upgrade the crawler's container. To avoid data inconsistency it might be a good idea to set the upgrade height in the .env as `STOP_HEIGHT=` and perform the container upgrade safely.

## Config options

Spacebox is configured over environment variables, set in the `.env` file.

> [!TIP]
> To apply .env changes just restart the `spacebox_crawler-1` container. However same does not apply to the rest of the containers(aka kafka or clickhouse), and they would need to be **recreated.**

### Crawler

---

`START_TIMEOUT`

Timeout to start application. Do not change without a strict purpose.

---

`STOP_TIMEOUT`

Timeout to stop application. Do not change without a strict purpose.

---

`LOG_LEVEL`

Supported values: `info`, `debug`,  `error`.

Debug level will produce more logs, including checks of the previously parsed blocks. Error log will show only errors if there's any.

---

`RECOVERY_MODE`

Default value: false

Intended for debugging purposes mostly. In case of *`panic`* will output a full error log, without crashing the crawler. Significantly(!) lowers the perfomance.

---

`START_HEIGHT`

Default value: 0

Height to start crawling from. Ex: for `cosmoshub-4` must be set to 5200792 as it was the first block in this chain.
If set to 0 genesis will be parced automatically.

---

`STOP_HEIGHT`

Default value: 0

Height to stop indexing at. Might be useful when necessary to index only certain parts of the chain. When set to 0 crawler will pull the latest block from the RPC at the moment of launch and use it as stop height.

---

`WORKERS_COUNT`

A number of the asynchronous Go workers inside the crawler. Recommended value: **<=** *CPU cores* in your system. A huge number of workers may exhaust the RPC node, resulting in missed blocks. Usually, more workers don't mean faster crawling, best performing number is 30-40 workers (even on 88-core machine).

---

`SUBSCRIBE_NEW_BLOCKS`

Default value: true

If set to **false**, the crawler will stop indexation on `STOP_HEIGHT` without an app crash. If set to **true**, the crawler will subscribe to the new coming blocks over the websocket and will parce them alongside to historical blocks.
>[Warning!] If SUBSCRIBE_NEW_BLOCKS=true `spacebox_crawler_last_processed_block_height` metric will display the highest indexed block, even though historical blocks might still be processed.

---

`PROCESS_ERROR_BLOCKS`

If set to **true** crawler will attempt to re-index the blocks that had errors during previous processing(based on info stored in Mongo). Re-indexation would be attempted every `PROCESS_ERROR_BLOCKS_INTERVAL`.

---

`PROCESS_GENESIS`

If set to **true** crawler will parce genesis to have genesis initial data in db. If `START_HEIGHT` set to 0 genesis would be parced as well.

### Text metrics

`METRICS_ENABLED`

Enable or disable crawler text metrics endpoint. Compatible with Prometheus.

`SERVER_PORT`

Specify the port for text metrics.

---

### Chain settings

`CHAIN_PREFIX`

Specify the account prefix for the chain you going to index. Typically found in the beginning of every address, e.g. for `cosmos106yp7zw35wftheyyv9f9pe69t8rteumjxjql7m` chain prefix is `cosmos`.

`RPC_URL` & `GRPC_URL`

Node RPC and GRPC endpoints. By default served on port 26657 and 9090.

>[TIP!] For better performance, we advise running the indexer as "close" to the chain node as possible, ideally on the same machine.

If you running both crawler and chain node on the same host you need to add the following line to the crawler's `docker-compose.yaml` section:

`docker-compose.yaml`

```diff
 ports:
 - '2112:2112'
+    extra_hosts:
+     - "host.docker.internal:host-gateway"
```

And set RPC and GRPC addresses in the `.env` accordingly:

```bash
RPC_URL=http://host.docker.internal:26657
GRPC_URL=host.docker.internal:9090 
```

Also, depending on your firewall setup, it might be required to allow connections from the docker subnet to the chain endpoint.

`GRPC_SECURE_CONNECTION`

Set to **true** if your GRPC endpoint running with SSL encryption enabled. Leave as **false** if connecting directly to node port or within the same localhost.

`GRPC_MAX_RECEIVE_MESSAGE_SIZE_BYTES`

Defines the maximum size of a single message crawler will process. If you see something similar to `...failed to get block: rpc error: code = ResourceExhausted desc = grpc: received message larger than max...` in the crawler log - increase this parameter and restart the container with spacebox_cralwer. Chains might have very heavy blocks, for ex. neutron's testnet pion-1 have some block_results of the size ~170mb.

---

### Broker settings

`BROKER_SERVER`

Address of Kafka broker. Do not change without a strict purpose.

`BROKER_ENABLED`

Enable\disable message publishing messages to the broker. Do not change without a strict purpose.

`PARTITIONS_COUNT`

Count of the partitions in the broker. Do not change without a strict purpose.

`MAX_MESSAGE_MAX_BYTES`

Define the maximum size of the message in Kafka. Requires Kafka container recreation.

`BATCH_PRODUCER`

Enable batch producer to process messages in Kafka by batches. Might increase performance, but considered an experimental feature.

`KAFKA_UI_PASSWORD`

Password for kafka-UI. Change for production deployment!

---

### Mongo settings

`MONGO_CRAWLER_URI`

Address of Mongo db. Crawler utilizes mongo-db as a check-list for parsed block status.

`MONGO_USER`

Mongo username used by the crawler.

`MONGO_PASSWORD`

Mongo user password used by the crawler. Change for production deployment!

`MAX_POOL_SIZE`

Maximum pool size in Mongo. Do not change without a strict purpose.

`MAX_CONNECTING`

Maximum Mongo connections. Do not change without a strict purpose.

---

### Clickhouse settings

`CLICKHOUSE_PASSWORD`

Password for clickhouse `default` user.  Change for production deployment! Default user will require some privileges upgrade to allow it [new users creation](https://clickhouse.com/docs/en/operations/access-rights#enabling-sql-user-mode).

---

### Health checker

`HEALTHCHECK_ENABLED`

If set to **true** the crawler will periodically check the health of the node endpoints, and behave accordingly.

`HEALTHCHECK_FATAL_ON_CHECK`

If set to **true** the crawler will crush if the health check has failed. That will result in a container restart.

`HEALTHCHECK_MAX_LAST_BLOCK_LAG`

Interval for the new block to appear in the RPC, to count endpoint healthy.

`HEALTHCHECK_INTERVAL`

Interval to perform a health check.

`HEALTHCHECK_START_DELAY`

Delay for the first health check after the start.
