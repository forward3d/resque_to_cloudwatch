require 'simple-graphite'

module ResqueToCloudwatch
  class GraphiteSender
    
    # Pass an instance of ResqueToCloudwatch::Config
    def initialize(config)
      @config = config
    end
    
    def send_value(value)
      graphite = Graphite.new({:host => @config.graphite_host, :port => @config.graphite_port})
      graphite.send_metrics({
        "resque_to_cloudwatch.#{@config.namespace}.#{@config.hostname}.#{@config.project}" => value
      })
      $log.info "GraphiteSender: sent metric value #{value}"
    end
    
    def inspect
      to_s
    end
    
    def to_s
      "GraphiteSender"
    end
    
  end
end
