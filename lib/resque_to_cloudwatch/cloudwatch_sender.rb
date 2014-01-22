require 'aws-sdk'

module ResqueToCloudwatch
  class CloudwatchSender
    
    # Pass an instance of CloudwatchToResque::Config
    def initialize(config)
      @config = config
    end
    
    def send_value(value, metric_name)
      dimensions = []
      dimensions << {:name => 'project', :value => @config.project}
      dimensions << {:name => 'hostname', :value => @config.hostname} unless @config.hostname.nil?
      cw = AWS::CloudWatch.new
      cw.client.put_metric_data({
        :namespace      => "#{@config.namespace}/resque",
        :metric_data    => [
          :metric_name  => metric_name,
          :dimensions   => dimensions,
          :value => value,
          :unit  => 'Count'
        ]
      })
      $log.info "CloudwatchSender: Sent metric value #{value} for #{metric_name}"
    end
    
    def inspect
      to_s
    end
    
    def to_s
      "CloudwatchSender"
    end
    
  end
  
end