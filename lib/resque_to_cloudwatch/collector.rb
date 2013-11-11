module ResqueToCloudwatch
  class Collector
   
    def initialize(config)
      @config = config
    end
    
    def get_queue_length
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:queues').map do |queue_key|
        redis.llen("resque:queue:#{queue_key}")
      end.reduce(:+)
    end
    
  end
end