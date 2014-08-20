# resque_to_cloudwatch

This is a gem containing a daemon for submitting Resque metrics to
AWS Cloudwatch. In addition, it can (optionally) submit these metrics to Graphite.

It collects and pushes the following metrics:
* number of jobs in all Resque queues (`resque_queues`)
* number of workers currently working (`resque_workers_working`)
* number of workers currently alive (`resque_workers_alive`)
* work remaining, which is workers working + queue length (`resque_work_remaining`)

## Usage

The daemon lives at `bin/resque_to_cloudwatch`, and takes only a single parameter:

    bin/resque_to_cloudwatch --config /path/to/config.yaml

If you don't supply this parameter, the daemon will look for a config file in the 
current directory.

## Configuration

The config file has the following format (in YAML):

    access_key_id: asdfasfasd
    secret_access_key: asdfasdfasf
    region: 
     - us-west-2
    project: testing
    hostname: laptop
    redis_host: some.redis.host
    redis_port: 6379
    period: 60
    namespace: F3D

#### `access_key_id`, `secret_access_key`

Your AWS access key/secret key pair.

#### `region`

Region(s) of Cloudwatch the metrics should be submitted to. This can either be a string, or
a list of regions to send the metric to.

#### `project`, `namespace`, `hostname`

These can actually contain any text - they are submitted as "dimensions" along
with the metric value. A single metric in Cloudwatch is uniquely identified by 
its name (hardcoded to `resque_queues`, `resque_workers_working` and `resque_workers_alive`
in this gem), and any dimensions it has. At Forward3D, we have a number of autoscaling "projects" 
(codebases), so we use the project dimension to represent that. Namespace is more 
important, as that determines how the metric is categorised in the Cloudwatch interface. 
Hostname can be anything, or blank - we set it to the hostname of the submitting machine.

#### `redis_host`, `redis_port`

Redis host and port.

#### `enable_graphite`, `graphite_host`, `graphite_port`

This gem can also send the metric it collects to Graphite - set `enable_graphite`
to `true`, and set the Graphite host and port if you want to the daemon to do this.

#### `period`

The period of the EventMachine loop - how often stats are collected and sent.

## Graphite metric

The Graphite metric name will look like this:

    resque_to_cloudwatch.namespace.metric_name.hostname.project
