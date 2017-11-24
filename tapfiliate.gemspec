# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tapfiliate/version'

Gem::Specification.new do |spec|
  spec.name          = 'tapfiliate'
  spec.version       = Tapfiliate::VERSION
  spec.authors       = ['Michel Abdo']
  spec.email         = ['michel.abdo@keeward.com']

  spec.summary       = 'Ruby gem for the Tapfiliate REST API.'
  spec.description   = 'Ruby methods to interact with the Tapfiliate endpoints.'
  spec.homepage      = 'http://github.com/bookwitty/tapfiliate'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing
  # to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.keeward.net'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'active_model_serializers'
  spec.add_dependency 'addressable'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'http'
  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
end
