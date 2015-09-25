require 'yaml'
require 'erb'
require 'aws-sdk'

module ResqueToCloudwatch
  class Config
   
    attr_reader :access_key_id, :secret_access_key, :project, :period, :region
    attr_reader :redis_host, :redis_port, :hostname
    attr_reader :graphite_host, :graphite_port, :enable_graphite
    attr_reader :namespace
   
    def initialize(path)
      $log.info "Loading configuration"
      raise "Config file #{path} not found or readable" unless File.exists?(path)
      @required_opts = %w{access_key_id secret_access_key project period region redis_host redis_port namespace}
      @hash = YAML.load(ERB.new(File.read(path)).result) rescue nil
      raise "Config file #{path} is empty" unless @hash
      validate_config
      @hash.each_pair do |opt,value|
        # Support old-style where region is not an array
        if opt == 'region' && value.is_a?(String)
          value = [value]
        end
        instance_variable_set("@#{opt}", value)
        $log.info "Config parameter: #{opt} is #{value}"
      end
      
      # Set up AWS credentials
      AWS.config(
        :access_key_id => @hash['access_key_id'],
        :secret_access_key => @hash['secret_access_key']
      )
    end
    
    private
    
    def validate_config
      missing_opts = @required_opts.select do |opt|
        @hash[opt].nil?
      end
      raise "Missing options: #{missing_opts.join(", ")}" unless missing_opts.empty?
      if @hash["enable_graphite"]
        raise "Graphite enabled but config missing graphite_host" if @hash["graphite_host"].nil?
        @hash["graphite_port"] ||= 2003
      else
        @hash["enable_graphite"] = false
      end
    end
    
  end
end
