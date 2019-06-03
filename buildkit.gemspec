# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buildkit/version'

Gem::Specification.new do |spec|
  spec.name          = 'buildkit'
  spec.version       = Buildkit::VERSION
  spec.authors       = ['Jean Boussier']
  spec.email         = ['jean.boussier@shopify.com']

  spec.summary       = 'Ruby toolkit for working with the Buildkite API'
  spec.homepage      = 'https://github.com/shopify/buildkit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'sawyer', '~> 0.6'
  spec.add_development_dependency 'bundler'
end
