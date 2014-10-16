# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'limdesk_api/version'


Gem::Specification.new do |spec|
  spec.name          = "limdesk_api"
  spec.version       = LimdeskApi::VERSION
  spec.authors       = ["Grzegorz Siehień"]
  spec.email         = ["grzegorz.siehien@limtel.com"]
  spec.summary       = %q{Gem for interacting with Limdesk.com}
  spec.description   = %q{Limdesk.com is a multichannel, web-based customer support solution. This gem lets you integrate your software using Limdesk's API.}
  spec.homepage      = "https://www.limdesk.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'
  spec.add_dependency 'faraday', '~> 0.9.0', '>= 0.9.0'
  spec.add_dependency 'faraday_middleware', '~> 0.9.1', '>= 0.9.0'
  spec.add_dependency 'recursive-open-struct', '~> 0.5.0', '>= 0.5.0'
  spec.add_dependency 'json', '~> 1.8.1', '>= 1.8.0'
end
