# Spacebox monitoring

Spacebox supports text-based metrics, compatible with [Prometheus](https://github.com/prometheus/prometheus). Port is mapped to the localhost in default docker-compose configuration, and could be configured in `.env`:

```bash
# Metrics settings
METRICS_ENABLED=true # Metrics enabled
SERVER_PORT=2112 # Metrics server port
```

To make it appear in Prometheus, launch crawler add a new target to your prometheus.yml, and restart Prometheus:

```bash
  - job_name: 'spacebox-crawler'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:2112']
```

An example of the Grafana dashboard can be found [here](./spacebox_grafana_sample.json). To make this board fully functional it's necessary to install [ClickHouse plugin](https://grafana.com/grafana/plugins/grafana-clickhouse-datasource/) to Grafana.

List of the supported metrics with some sample values:

```bash
# HELP client_api_requests_total A counter for requests from the wrapped client.
# TYPE client_api_requests_total counter
client_api_requests_total{code="200",method="post"} 235915
# HELP client_in_flight_requests A gauge of in-flight requests for the wrapped client.
# TYPE client_in_flight_requests gauge
client_in_flight_requests 0
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="*"} 0.00013202
go_gc_duration_seconds_sum 569.665748093
go_gc_duration_seconds_count 320180
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 144
# HELP go_info Information about the Go environment.
# TYPE go_info gauge
go_info{version="go1.22.4"} 1
# HELP go_memstats_alloc_bytes Number of bytes allocated and still in use.
# TYPE go_memstats_alloc_bytes gauge
go_memstats_alloc_bytes 3.5313344e+08
# HELP go_memstats_alloc_bytes_total Total number of bytes allocated, even if freed.
# TYPE go_memstats_alloc_bytes_total counter
go_memstats_alloc_bytes_total 1.49838467006912e+14
# HELP go_memstats_buck_hash_sys_bytes Number of bytes used by the profiling bucket hash table.
# TYPE go_memstats_buck_hash_sys_bytes gauge
go_memstats_buck_hash_sys_bytes 7.119855e+06
# HELP go_memstats_frees_total Total number of frees.
# TYPE go_memstats_frees_total counter
go_memstats_frees_total 2.228701493759e+12
# HELP go_memstats_gc_sys_bytes Number of bytes used for garbage collection system metadata.
# TYPE go_memstats_gc_sys_bytes gauge
go_memstats_gc_sys_bytes 4.607688e+07
# HELP go_memstats_heap_alloc_bytes Number of heap bytes allocated and still in use.
# TYPE go_memstats_heap_alloc_bytes gauge
go_memstats_heap_alloc_bytes 3.5313344e+08
# HELP go_memstats_heap_idle_bytes Number of heap bytes waiting to be used.
# TYPE go_memstats_heap_idle_bytes gauge
go_memstats_heap_idle_bytes 3.821551616e+09
# HELP go_memstats_heap_inuse_bytes Number of heap bytes that are in use.
# TYPE go_memstats_heap_inuse_bytes gauge
go_memstats_heap_inuse_bytes 3.74980608e+08
# HELP go_memstats_heap_objects Number of allocated objects.
# TYPE go_memstats_heap_objects gauge
go_memstats_heap_objects 4.765757e+06
# HELP go_memstats_heap_released_bytes Number of heap bytes released to OS.
# TYPE go_memstats_heap_released_bytes gauge
go_memstats_heap_released_bytes 3.750273024e+09
# HELP go_memstats_heap_sys_bytes Number of heap bytes obtained from system.
# TYPE go_memstats_heap_sys_bytes gauge
go_memstats_heap_sys_bytes 4.196532224e+09
# HELP go_memstats_last_gc_time_seconds Number of seconds since 1970 of last garbage collection.
# TYPE go_memstats_last_gc_time_seconds gauge
go_memstats_last_gc_time_seconds 1.726229858651255e+09
# HELP go_memstats_lookups_total Total number of pointer lookups.
# TYPE go_memstats_lookups_total counter
go_memstats_lookups_total 0
# HELP go_memstats_mallocs_total Total number of mallocs.
# TYPE go_memstats_mallocs_total counter
go_memstats_mallocs_total 2.228706259516e+12
# HELP go_memstats_mcache_inuse_bytes Number of bytes in use by mcache structures.
# TYPE go_memstats_mcache_inuse_bytes gauge
go_memstats_mcache_inuse_bytes 105600
# HELP go_memstats_mcache_sys_bytes Number of bytes used for mcache structures obtained from system.
# TYPE go_memstats_mcache_sys_bytes gauge
go_memstats_mcache_sys_bytes 109200
# HELP go_memstats_mspan_inuse_bytes Number of bytes in use by mspan structures.
# TYPE go_memstats_mspan_inuse_bytes gauge
go_memstats_mspan_inuse_bytes 5.52096e+06
# HELP go_memstats_mspan_sys_bytes Number of bytes used for mspan structures obtained from system.
# TYPE go_memstats_mspan_sys_bytes gauge
go_memstats_mspan_sys_bytes 6.190176e+07
# HELP go_memstats_next_gc_bytes Number of heap bytes when next garbage collection will take place.
# TYPE go_memstats_next_gc_bytes gauge
go_memstats_next_gc_bytes 4.86296432e+08
# HELP go_memstats_other_sys_bytes Number of bytes used for other system allocations.
# TYPE go_memstats_other_sys_bytes gauge
go_memstats_other_sys_bytes 1.5349049e+07
# HELP go_memstats_stack_inuse_bytes Number of bytes in use by the stack allocator.
# TYPE go_memstats_stack_inuse_bytes gauge
go_memstats_stack_inuse_bytes 1.0354688e+07
# HELP go_memstats_stack_sys_bytes Number of bytes obtained from system for stack allocator.
# TYPE go_memstats_stack_sys_bytes gauge
go_memstats_stack_sys_bytes 1.0354688e+07
# HELP go_memstats_sys_bytes Number of bytes obtained from system.
# TYPE go_memstats_sys_bytes gauge
go_memstats_sys_bytes 4.337443656e+09
# HELP go_threads Number of OS threads created.
# TYPE go_threads gauge
go_threads 100
# HELP grpc_client_handled_total Total number of RPCs completed by the client, regardless of success or failure.
# TYPE grpc_client_handled_total counter
grpc_client_handled_total{grpc_code="OK",grpc_method="*",grpc_service="*",grpc_type="unary"} 117957
# HELP grpc_client_handling_seconds Histogram of response latency (seconds) of the gRPC until it is finished by the application.
# TYPE grpc_client_handling_seconds histogram
grpc_client_handling_seconds_bucket{grpc_method="*",grpc_service="*",grpc_type="unary",le="0.005"} 0
grpc_client_handling_seconds_sum{grpc_method="*",grpc_service="*",grpc_type="unary"} 1704.9106808000047
grpc_client_handling_seconds_count{grpc_method="*",grpc_service="*",grpc_type="unary"} 117957
# HELP grpc_client_msg_received_total Total number of RPC stream messages received by the client.
# TYPE grpc_client_msg_received_total counter
grpc_client_msg_received_total{grpc_method="*",grpc_service="*",grpc_type="unary"} 117957
# HELP grpc_client_msg_sent_total Total number of gRPC stream messages sent by the client.
# TYPE grpc_client_msg_sent_total counter
grpc_client_msg_sent_total{grpc_method="*",grpc_service="*",grpc_type="unary"} 117957
# HELP grpc_client_started_total Total number of RPCs started on the client.
# TYPE grpc_client_started_total counter
grpc_client_started_total{grpc_method="*",grpc_service="*",grpc_type="unary"} 117957
# HELP mongo_commands Histogram of MongoDB commands
# TYPE mongo_commands histogram
mongo_commands_bucket{command="*",instance="*",le="*"} 6706
mongo_commands_sum{command="*",instance="*"} 46649.20434609119
mongo_commands_count{command="*",instance="*"} 13632
# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 3.77212593e+06
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1.048576e+06
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 36
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 5.58522368e+08
# HELP process_start_time_seconds Start time of the process since unix epoch in seconds.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1.72552562346e+09
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 5.791121408e+09
# HELP process_virtual_memory_max_bytes Maximum amount of virtual memory available in bytes.
# TYPE process_virtual_memory_max_bytes gauge
process_virtual_memory_max_bytes 1.8446744073709552e+19
# HELP promhttp_metric_handler_requests_in_flight Current number of scrapes being served.
# TYPE promhttp_metric_handler_requests_in_flight gauge
promhttp_metric_handler_requests_in_flight 1
# HELP promhttp_metric_handler_requests_total Total number of scrapes by HTTP status code.
# TYPE promhttp_metric_handler_requests_total counter
promhttp_metric_handler_requests_total{code="*"} 140841
# HELP request_duration_seconds A histogram of request latencies.
# TYPE request_duration_seconds histogram
request_duration_seconds_bucket{method="post",le="*"} 1
request_duration_seconds_sum{method="post"} 5616.343836235997
request_duration_seconds_count{method="post"} 235915
# HELP spacebox_crawler_blocks_by_status Total blocks for each status
# TYPE spacebox_crawler_blocks_by_status gauge
spacebox_crawler_blocks_by_status{status="error"} 1.046201e+06
spacebox_crawler_blocks_by_status{status="processed"} 1.6964531e+07
spacebox_crawler_blocks_by_status{status="processing"} 0
# HELP spacebox_crawler_last_processed_block_height Last processed block height
# TYPE spacebox_crawler_last_processed_block_height gauge
spacebox_crawler_last_processed_block_height 2.216532e+07
# HELP spacebox_crawler_process_duration Duration of parsed blockchain objects
# TYPE spacebox_crawler_process_duration histogram
spacebox_crawler_process_duration_bucket{type="*",le="*"} 117957
spacebox_crawler_process_duration_sum{type="*"} 0.48113770700000247
spacebox_crawler_process_duration_count{type="*"} 117957
# HELP spacebox_crawler_start_height Start height for processing
# TYPE spacebox_crawler_start_height gauge
spacebox_crawler_start_height 1.8e+07
# HELP spacebox_crawler_stop_height Stop height for processing
# TYPE spacebox_crawler_stop_height gauge
spacebox_crawler_stop_height 2.2047366e+07
# HELP spacebox_crawler_total_error_messages Total error messages
# TYPE spacebox_crawler_total_error_messages gauge
spacebox_crawler_total_error_messages 0
# HELP spacebox_crawler_total_error_txs Total error txs
# TYPE spacebox_crawler_total_error_txs gauge
spacebox_crawler_total_error_txs 6.719612e+06
# HELP spacebox_crawler_total_workers Count of workers
# TYPE spacebox_crawler_total_workers gauge
spacebox_crawler_total_workers 5
# HELP spacebox_crawler_version Crawler version
# TYPE spacebox_crawler_version gauge
spacebox_crawler_version{version="v2.0.0"} 1
# HELP spacebox_crawler_worker_recovery_mode Is worker recovery mode enabled
# TYPE spacebox_crawler_worker_recovery_mode gauge
spacebox_crawler_worker_recovery_mode 0
```
