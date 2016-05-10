# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday/http/signatures/version'

Gem::Specification.new do |s|
  s.name = 'faraday-http-signatures'
  s.version = Faraday::Http::Signatures::VERSION
  s.authors = ['Richard Nienaber', 'Igor Kim']
  s.email = ['richard.nienaber@currencycloud.com', 'yorikim@gmail.com']

  s.summary = 'Faraday middleware that implement draft 5 of the HTTP Signatures spec'
  s.description = 'Faraday middleware that implement draft 5 of the HTTP Signatures spec'
  s.homepage = 'https://github.com/CurrencyCloud/faraday-http-signatures'
  s.licenses = ['MIT']
  s.required_ruby_version = '>= 1.9'

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.12'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rubocop', '~> 0.39.0'
  s.add_runtime_dependency 'faraday', '~> 0.9'
end
