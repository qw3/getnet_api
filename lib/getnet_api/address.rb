# -*- encoding : utf-8 -*-
module GetnetApi
  class Address

    # Endereço (Logradouro)
    # Alfa Numérico - Até 60 caracteres
    attr_accessor :street

    # Número do logradouro
    # Alfa Numérico - Até 10 caracteres
    attr_accessor :number

    # Complemento do endereço comprador
    # Alfa Numérico - Até 60 caracteres
    attr_accessor :complement

    # Bairro do logradouro
    # Alfa Numérico - Até 40 caracteres
    attr_accessor :district

    # Cidade do logradouro
    # Alfa Numérico - Até 40 caracteres
    attr_accessor :city

    # Estado do logradouro (UF)
    # Alfa Numérico - Até 20 caracteres
    attr_accessor :state

    # País do logradouro
    # Alfa Numérico - Até 20 caracteres
    attr_accessor :country

    # Código Postal, CEP no Brasil ou ZIP nos Estados Unidos. (sem máscara)
    # Alfa Numérico - Até 10 caracteres
    attr_accessor :postal_code

    # Definir country
    def country
      @country ||= "Brasil"
    end

    # Validações do Rails 3
    include ActiveModel::Validations

    # Validações
    validates :street, length: { maximum: 60 }
    validates :number, length: { maximum: 10 }
    validates :complement, length: { maximum: 60 }
    validates :district, :city, length: { maximum: 40 }
    validates :state, :country, length: { maximum: 20 }
    validates :postal_code, length: { maximum: 8 }

    # Nova instancia da classe Endereco
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Address.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de Endereco no padrão utilizado pela GetnetApi
    def to_request
      address = {
        street:       self.street,
        number:       self.number,
        complement:   self.complement,
        district:     self.district,
        city:         self.city,
        state:        self.state,
        postal_code:  self.postal_code,
        country:      self.country,
      }
      return address
    end

  end
end
