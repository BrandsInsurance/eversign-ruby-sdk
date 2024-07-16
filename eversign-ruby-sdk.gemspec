# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'eversign/version'

Gem::Specification.new do |spec|
  spec.name = 'eversign'
  spec.version = Eversign::VERSION
  spec.authors = ['Sachin Raka']
  spec.email = ['Sachin.Raka@outlook.com']

  spec.summary = 'Gem for Eversign API Client.'
  spec.description = 'Gem for Eversign API SDK.'
  spec.homepage = 'https://github.com/workatbest/eversign-ruby-sdk'
  spec.license = 'MIT'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'CHANGELOG.md', 'LICENSE.txt', 'CONTRIBUTING.md']
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = ['>= 3.0.1', '< 4']

  spec.add_dependency('addressable', '~> 2.5')
  spec.add_dependency('configurations', '~> 2.2')
  spec.add_dependency('faraday', '>= 0.13')
  spec.add_dependency('faraday-multipart', '1.0.3')
  spec.add_dependency('kartograph', '~> 0.2.3')
  spec.add_dependency('rails', '>= 4')

  spec.add_development_dependency('bundler', '~> 2')
  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_development_dependency('simplecov', '0.22.0')

  spec.add_development_dependency('rubocop-rubomatic', '>= 1.0.0', '< 2.0')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
