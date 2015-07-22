# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid_api/version'

Gem::Specification.new do |spec|
  spec.name          = "sendgrid_api"
  spec.version       = SendGrid::VERSION
  spec.authors       = ["Pedro Axelrud"]
  spec.email         = ["pedro@mailee.me"]
  spec.description   = "Basic integration with Sendgrid"
  spec.summary       = "Communicate with Sendgrid"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
