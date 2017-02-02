# encoding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'attask/version'

Gem::Specification.new do |spec|
  spec.name         = 'attask'
  spec.version      = Attask::VERSION
  spec.platform     = Gem::Platform::RUBY
  spec.authors      = ['Paulo Henrique Bruce']
  spec.email        = ['brucepaulohenrique@gmail.com']
  spec.homepage     = 'https://github.com/phbruce/attask'
  spec.summary      = 'Ruby interface for the Attask API'
  spec.description  = 'This gem is prepared to integrate with Attask'

  spec.required_rubygems_version = '>= 1.3.6'
  spec.license = 'MIT'

  spec.add_runtime_dependency('addressable', '~> 2.5')
  spec.add_runtime_dependency('faraday', '~> 0.11')
  spec.add_runtime_dependency('oj', '~> 2.18')
  spec.add_runtime_dependency('patron', '~> 0.8')
  spec.add_development_dependency('rspec', '~> 3.5')

  spec.files        = Dir['README.md', 'Gemfile', 'lib/**/*']
  spec.test_files   = `git ls-files -- spec/*`.split("\n")
  spec.require_path = 'lib'
end
