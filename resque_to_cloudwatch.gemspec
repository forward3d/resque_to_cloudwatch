# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque_to_cloudwatch/version'

Gem::Specification.new do |spec|
  spec.name          = "resque_to_cloudwatch"
  spec.version       = ResqueToCloudwatch::VERSION
  spec.authors       = ["Andy Sykes"]
  spec.email         = ["github@tinycat.co.uk"]
  spec.description   = %q{Submit Resque queue lengths to Cloudwatch}
  spec.summary       = %q{Submit Resque queue lengths to AWS Cloudwatch}
  spec.homepage      = "https://github.com/forward3d/resque_to_cloudwatch"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency "aws-sdk", "= 3.0.1"
  spec.add_dependency "eventmachine", "= 1.0.3"
  spec.add_dependency "redis", "= 3.0.6"
  spec.add_dependency "simple-graphite", "~> 2.1.0"
  
end
