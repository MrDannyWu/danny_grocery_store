### Prometheus 安装
```shell

# 启动各个机器的 node_exporter (nn-99--dn-103)

nohup /usr/local/node_exporter-1.6.0.linux-amd64/node_exporter --web.listen-address 0.0.0.0:9527 > node_exporter.log 2>&1 &

# 启动 99 的 pushgateway
nohup /usr/local/pushgateway-1.6.0.linux-amd64/pushgateway --web.listen-address=":9091" > pushgateway.log 2>&1 &

# 启动 99 的 Prometheus
nohup /usr/local/prometheus-2.45.0.linux-amd64/prometheus --web.enable-admin-api --config.file=prometheus.yml > prometheus.log 2>&1 &

```

### 更改 Prometheus 配置
```shell
vim /usr/local/prometheus-2.45.0.linux-amd64/ prometheus.yml
# 修改下面的地方
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["192.168.101.99:9090"]
    # 采集node exporter监控数据
  - job_name: 'node'
    static_configs:
      - targets: ['192.168.101.99:9527', '192.168.101.100:9527', '192.168.101.101:9527', '192.168.101.102:9527', '192.168.101.103:9527']
  - job_name: 'pushgateway'
    static_configs:
      - targets: ['192.168.101.99:9091']


```



### flink 配置
1. 添加 Jar 包
```shell
# 在 nn-99 执行
ssh nn-100 wget -P /usr/local/flink-1.17.1/lib https://repo1.maven.org/maven2/org/apache/flink/flink-metrics-prometheus/1.17.1/flink-metrics-prometheus-1.17.1.jar
cd /usr/local/flink-1.17.1/lib
scp nn-100:/usr/local/flink-1.17.1/lib/flink-metrics-prometheus-1.17.1.jar .
xsync /usr/local/flink-1.17.1/lib/flink-metrics-prometheus-1.17.1.jar
```

```shell
metrics.reporter.promgateway.class: org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter
# PushGateway的host和port
metrics.reporter.promgateway.host: nn-99
metrics.reporter.promgateway.port: 9091
# Flink metric在前端展示的标签(前缀)
metrics.reporter.promgateway.jobName: flink-cluster-metrics
# 是否在Flink metric的标签添加随机后缀
metrics.reporter.promgateway.randomJobNameSuffix: true
# Flink集群关闭时，是否删除Pushgateway中的Flink metrics
metrics.reporter.promgateway.deleteOnShutdown: false
# Flink向Pushgateway推送metrics的时间间隔
metrics.reporter.promgateway.interval: 60 SECONDS


metrics.reporter.promgateway.factory.class: org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporterFactory
metrics.reporter.promgateway.hostUrl: http://192.168.101.99:9091
metrics.reporter.promgateway.jobName: flink-cluster-metrics
metrics.reporter.promgateway.randomJobNameSuffix: true
metrics.reporter.promgateway.deleteOnShutdown: false
metrics.reporter.promgateway.interval: 60 SECONDS

```