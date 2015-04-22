# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
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

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency 'sawyer', '~> 0.6.0'
  spec.add_development_dependency 'bundler', '~> 1.9'
end
