# resque_to_cloudwatch

This is a gem containing a daemon for submitting Resque queue lengths to AWS
Cloudwatch.

## Usage

The daemon lives at `bin/resque_to_cloudwatch`, and takes only a single parameter:

    bin/resque_to_cloudwatch --config /path/to/config.yaml

If you don't supply this parameter, the daemon will look for a config file in the 
current directory.

The config file has the following format (in YAML):

    access_key_id: asdfasfasd
    secret_access_key: asdfasdfasf
    region: us-west-2
    project: testing
    hostname: laptop
    redis_host: some.redis.host
    redis_port: 6379
    period: 60