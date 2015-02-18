module ResqueToCloudwatch
  class QueueLengthCollector
   
    def initialize(config)
      @config = config
    end
    
    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:queues').map do |queue_key|
        redis.llen("resque:queue:#{queue_key}")
      end.reduce(:+)
    end
    
    def metric_name
      "resque_queues"
    end
    
    def to_s
      metric_name
    end
    
  end

  class HighPriorityQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      %w[ instant date_and_time ].map do |queue_key|
        redis.llen("resque:queue:#{queue_key}")
      end.reduce(:+)
    end

    def metric_name
      "high_priority_resque_queues"
    end

    def to_s
      metric_name
    end

  end

  class MiniQueueQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.llen("resque:queue:mini_queue")
    end

    def metric_name
      "mini_queue_resque_queue"
    end

    def to_s
      metric_name
    end

  end

  class InstantQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.llen("resque:queue:instant")
    end

    def metric_name
      "instant_resque_queue"
    end

    def to_s
      metric_name
    end

  end

  class DateTimeQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.llen("resque:queue:date_and_time")
    end

    def metric_name
      "datetime_resque_queue"
    end

    def to_s
      metric_name
    end

  end

  class DoRecipesQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.llen("resque:queue:do_recipes")
    end

    def metric_name
      "do_resque_queue"
    end

    def to_s
      metric_name
    end

  end

  class FailedQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.llen("resque:failed")
    end

    def metric_name
      "failed_queue_resque_queue"
    end

    def to_s
      metric_name
    end

  end

  class WorkersWorkingCollector
    
    def initialize(config)
      @config = config
    end
    
    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:workers').select do |worker_key|
        redis.exists("resque:worker:#{worker_key}")
      end.length
    end
    
    def metric_name
      "resque_workers_working"
    end
    
    def to_s
      metric_name
    end
    
  end
  
  class WorkersAliveCollector
    
    def initialize(config)
      @config = config
    end
    
    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:workers').length
    end
    
    def metric_name
      "resque_workers_alive"
    end
    
    def to_s
      metric_name
    end
    
  end
  
  class WorkRemainingCollector
    
    def initialize(config)
      @config = config
    end
    
    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      working = redis.smembers('resque:workers').select do |worker_key|
        redis.exists("resque:worker:#{worker_key}")
      end.length
      queue_length = redis.smembers('resque:queues').map do |queue_key|
        redis.llen("resque:queue:#{queue_key}")
      end.reduce(:+)
      working + queue_length
    end
    
    def metric_name
      "resque_work_remaining"
    end
    
    def to_s
      metric_name
    end
    
  end

  class ResqueSchedulerDelayedQueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.zcard('resque:delayed_queue_schedule')
    end

    def metric_name
      "resque_scheduler_delayed_queue"
    end

    def to_s
      metric_name
    end
  end

  class ResqueSchedulerDelayedQueueDriftCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      timestamp = redis.zrange('resque:delayed_queue_schedule', 0, 0).first.to_i
      drift = timestamp - Time.now.to_i
    end

    def metric_name
      "resque_scheduler_delayed_queue_drift"
    end

    def to_s
      metric_name
    end
end
