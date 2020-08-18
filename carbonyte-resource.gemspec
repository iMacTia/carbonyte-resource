# frozen_string_literal: true

require_relative 'lib/carbonyte/resource/version'

Gem::Specification.new do |spec|
  spec.name        = 'carbonyte-resource'
  spec.version     = Carbonyte::Resource::VERSION
  spec.authors     = ['iMacTia']
  spec.email       = ['giuffrida.mattia@gmail.com']
  spec.homepage    = 'https://github.com/iMacTia/carbonyte-resource'
  spec.summary     = 'Access Resources from other Carbonyte Microservices.'
  spec.description = 'Access Resources from other Carbonyte Microservices.'
  spec.license     = 'MIT'
  spec.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.add_dependency 'carbonyte-support'
  spec.add_dependency 'json_api_client', '~> 1.16'
  spec.add_dependency 'request_store', '~> 1.5'

  spec.add_development_dependency 'inch', '~> 0.8'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.89'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
end
