require 'logger'
$log = Logger.new(STDOUT)

require_relative "resque_to_cloudwatch/config.rb"
require_relative "resque_to_cloudwatch/sender.rb"
require_relative "resque_to_cloudwatch/collector.rb"