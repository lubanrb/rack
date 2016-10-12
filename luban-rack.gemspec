# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'luban/deployment/applications/rack/version'

Gem::Specification.new do |spec|
  spec.name          = "luban-rack"
  spec.version       = Luban::Deployment::Applications::Rack::VERSION
  spec.authors       = ["Rubyist Chi"]
  spec.email         = ["rubyist.chi@gmail.com"]

  spec.summary       = %q{Rack support for Luban}
  spec.description   = %q{Luban::Rack is a Luban deployment application to manage Rack based web application deployment and control}
  spec.homepage      = "https://github.com/lubanrb/rack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1.0"
  spec.add_dependency 'luban', ">= 0.9.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
