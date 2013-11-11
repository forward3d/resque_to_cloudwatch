require 'yaml'
require 'aws-sdk'

module ResqueToCloudwatch
  class Config
   
    attr_reader :access_key_id, :secret_access_key, :project, :period, :region
    attr_reader :redis_host, :redis_port, :hostname
   
    def initialize(path)
      $log.info "Loading configuration"
      raise "Config file #{path} not found or readable" unless File.exists?(path)
      @required_opts = %w{access_key_id secret_access_key project period region redis_host redis_port hostname}
      @hash = YAML.load_file(path)
      raise "Config file #{path} is empty" unless @hash
      validate_config
      @required_opts.each do |opt|
        instance_variable_set("@#{opt}", @hash[opt])
        $log.info "Config parameter: #{opt} is #{@hash[opt]}"
      end
      
      # Set up AWS credentials
      AWS.config(
        :access_key_id => @hash['access_key_id'],
        :secret_access_key => @hash['secret_access_key'],
        :region => @hash['region']
      )
    end
    
    private
    
    def validate_config
      missing_opts = @required_opts.select do |opt|
        @hash[opt].nil?
      end
      raise "Missing options: #{missing_opts.join(", ")}" unless missing_opts.empty?
    end
    
  end
end