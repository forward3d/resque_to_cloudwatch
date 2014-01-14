# resque_to_cloudwatch

This is a gem containing a daemon for submitting Resque queue lengths and the number
of Resque workers currently working to AWS Cloudwatch. In addition, it can (optionally) 
submit this metric to Graphite.

## Usage

The daemon lives at `bin/resque_to_cloudwatch`, and takes only a single parameter:

    bin/resque_to_cloudwatch --config /path/to/config.yaml

If you don't supply this parameter, the daemon will look for a config file in the 
current directory.

## Configuration

The config file has the following format (in YAML):

    access_key_id: asdfasfasd
    secret_access_key: asdfasdfasf
    region: us-west-2
    project: testing
    hostname: laptop
    redis_host: some.redis.host
    redis_port: 6379
    period: 60
    namespace: F3D

#### `access_key_id`, `secret_access_key`

Your AWS access key/secret key pair.

#### `region`

Region of Cloudwatch the metrics should be submitted to.

#### `project`, `namespace`, `hostname`

These can actually contain any text - they are submitted as "dimensions" along
with the metric value. A single metric in Cloudwatch is uniquely identified by 
its name (hardcoded to `jobs_queued` and `workers_working` in this gem), and any 
dimensions it has. At Forward3D, we have a number of autoscaling "projects" 
(codebases), so we use the project dimension to represent that. Namespace is more 
important, as that determines how the metric is categorised in the Cloudwatch interface. 
Hostname can be anything - we set it to the hostname of the submitting machine.

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
