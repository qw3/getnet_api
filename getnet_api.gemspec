# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'getnet_api/version'

Gem::Specification.new do |spec|
  spec.name                   = "getnet_api"
  spec.version                = GetnetApi::Version::STRING
  spec.platform               = Gem::Platform::RUBY
  spec.authors                = ["QW3 Software & Marketing"]
  spec.email                  = ["contato@qw3.com.br"]
  spec.summary                = "Getnet API - Meios de Pagamento"
  spec.description            = "Gem para utilização dos meios de pagamento Getnet - Uma empresa Santander para integrar sua plataforma de forma segura e eficaz com as principais formas de pagamento disponíveis no mercado."
  spec.homepage               = "https://github.com/qw3/getnet_api"
  spec.license                = "MIT"

  spec.files                  = `git ls-files`.split($/)
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths          = ["lib"]

  spec.required_ruby_version  = Gem::Requirement.new(">= 1.9")

  spec.add_dependency 'rest-client', '>= 1.7.3'

end
