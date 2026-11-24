# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buildkit/version'

Gem::Specification.new do |spec|
  spec.name          = 'buildkit'
  spec.version       = Buildkit::VERSION
  spec.authors       = ['Jean Boussier']
  spec.email         = ['jean.boussier@shopify.com']

  spec.summary       = '[Deprecated] Ruby toolkit for working with the Buildkite API'
  spec.description   = 'No longer maintained: the repository is archived and receives no updates or security fixes.'
  spec.homepage      = 'https://github.com/shopify/buildkit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.post_install_message = <<~MESSAGE
    buildkit is no longer maintained. Its repository is archived and it receives no
    updates or security fixes. See https://github.com/Shopify/buildkit
  MESSAGE

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'sawyer', '>= 0.6'
  spec.add_development_dependency 'bundler'
end
