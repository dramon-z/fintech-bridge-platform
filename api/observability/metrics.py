from prometheus_client import Counter, Histogram

transfer_success = Counter(
    "transfer_success_total",
    "Total successful transfers"
)

transfer_fail = Counter(
    "transfer_fail_total",
    "Total failed transfers"
)

transfer_latency = Histogram(
    "transfer_latency_seconds",
    "Transfer processing time"
)