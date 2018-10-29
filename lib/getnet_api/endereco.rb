# -*- encoding : utf-8 -*-
module GetnetApi
  class Endereco

    # Endereço (Logradouro)
    # Alfa Numérico - Até 60 caracteres
    attr_accessor :logradouro

    # Número do logradouro
    # Alfa Numérico - Até 10 caracteres
    attr_accessor :numero

    # Complemento do endereço comprador
    # Alfa Numérico - Até 60 caracteres
    attr_accessor :complemento

    # Bairro do logradouro
    # Alfa Numérico - Até 40 caracteres
    attr_accessor :bairro

    # Cidade do logradouro
    # Alfa Numérico - Até 40 caracteres
    attr_accessor :cidade

    # Estado do logradouro (UF)
    # Alfa Numérico - Até 20 caracteres
    attr_accessor :estado

    # País do logradouro
    # Alfa Numérico - Até 20 caracteres
    attr_accessor :pais

    # Código Postal, CEP no Brasil ou ZIP nos Estados Unidos. (sem máscara)
    # Alfa Numérico - Até 10 caracteres
    attr_accessor :cep

    # Definir pais
    def pais
      @pais ||= "Brasil"
    end

    # Validações do Rails 3
    include ActiveModel::Validations

    # Validações
    validates :logradouro, length: { maximum: 60 }
    validates :numero, length: { maximum: 10 }
    validates :complemento, length: { maximum: 60 }
    validates :bairro, :cidade, length: { maximum: 40 }
    validates :estado, :pais, length: { maximum: 20 }
    validates :cep, length: { maximum: 8 }

    # Nova instancia da classe Endereco
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Endereco.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de Endereco no padrão utilizado pela GetnetApi
    def to_request
      billing_address = {
        street:       self.logradouro,
        number:       self.numero,
        complement:   self.complemento,
        district:     self.bairro,
        city:         self.cidade,
        state:        self.estado,
        postal_code:  self.cep,
        country:      self.pais,
      }
      return billing_address
    end

  end
end
