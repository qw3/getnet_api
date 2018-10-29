# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'getnet_api/version'

Gem::Specification.new do |spec|
  spec.name                  = "getnet_api"
  spec.version               = GetnetApi::Version::STRING
  spec.platform              = Gem::Platform::RUBY
  spec.authors               = ["QW3 Software & Marketing"]
  spec.email                 = ["contato@qw3.com.br"]
  spec.summary               = "Getnet API - Meios de Pagamento"
  spec.description           = "Gem para utilização dos meios de pagamento Getnet - Uma empresa Santander para integrar sua plataforma de forma segura e eficaz com as principais formas de pagamento disponíveis no mercado."
  spec.homepage              = "https://github.com/qw3/getnet_api"
  spec.license               = "MIT"

  spec.files                 = [
                                "lib/getnet_api.rb",
                                "lib/getnet_api/version.rb",
                                "lib/getnet_api/configuracao.rb",
                                "lib/getnet_api/helper.rb",
                                "lib/getnet_api/web_service.rb",
                                "lib/getnet_api/forma_de_pagamento.rb",
                                "lib/getnet_api/status.rb",
                                "lib/getnet_api/endereco.rb",
                                "lib/getnet_api/telefone.rb",
                                "lib/getnet_api/dados_usuario.rb",
                                "lib/getnet_api/item_pedido.rb",
                                "lib/getnet_api/transacao.rb",
                                "lib/getnet_api/retorno.rb",
                              ]
  spec.require_paths         = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 1.9")

  spec.add_dependency 'rest-client'
  spec.add_dependency "activemodel",     ">= 3"
  spec.add_runtime_dependency "savon",   ">= 2.11"

end
