require 'aws-sdk'

module ResqueToCloudwatch
  class CloudwatchSender
    
    # Pass an instance of CloudwatchToResque::Config
    def initialize(config)
      @config = config
    end
    
    def send_value(value)
      cw = AWS::CloudWatch.new
      cw.client.put_metric_data({
        :namespace      => 'F3D/resque_queues',
        :metric_data    => [
          :metric_name  => "jobs_queued",
          :dimensions   => [
            {
              :name  => 'hostname',
              :value => @config.hostname
            },
            {
              :name  => 'project',
              :value => @config.project
            }
          ],
          :value => value,
          :unit  => 'Count'
        ]
      })
      $log.info "CloudwatchSender: Sent metric value #{value}"
    end
    
    def inspect
      to_s
    end
    
    def to_s
      "CloudwatchSender"
    end
    
  end
  
end