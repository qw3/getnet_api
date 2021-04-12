# -*- encoding : utf-8 -*-
module GetnetApi
  class Customer < Base

    # Opções de Tipo de Cliente
    TIPO_DOCUMENTO = {
      :pessoa_fisica    => "CPF",
      :pessoa_juridica  => "CNPJ",
    }

    # Código que identifica o cliente no estabelecimento.
    # Alfa Numérico - Até 20 caracteres
    attr_accessor :customer_id

    # Nome do comprador
    # Alfa Numérico - Até 40 caracteres
    attr_accessor :first_name

    # Nome do comprador
    # Alfa Numérico - Até 80 caracteres
    attr_accessor :last_name

    # Nome do comprador
    # Alfa Numérico - Até 100 caracteres
    attr_accessor :name

    # E-mail do comprador
    # Alfa Numérico - Até 100 caracteres
    attr_accessor :email

    # Identifica o tipo de documento informado é pessoa física ou jurídica.
    # Simbolo - Valores pré-definidos [:pessoa_fisica, :pessoa_juridica]
    attr_accessor :document_type

    # Número do documento do comprador sem pontuação. (sem máscara)
    # Alfa Numérico - Até 15 caracteres
    attr_accessor :document_number

    # Endereços
    # GetnetApi::Address
    attr_accessor :address

    # Telefone do comprador. (sem máscara)
    # Alfa Numérico - Até 15 caracteres
    attr_accessor :phone_number

    # Celular do comprador. (sem máscara)
    # Alfa Numérico - Até 15 caracteres
    attr_accessor :celphone_number

    attr_accessor :observation

    # Validações do Rails 3
    include ActiveModel::Validations

    # Retornar array com os possíveis tipos de cliente
    def self.tipos_document_number_validos
      TIPO_DOCUMENTO.map{ |key, value| key }
    end

    # Validações
    validates :customer_id, length: { maximum: 100 }
    validates :first_name, length: { maximum: 40 }
    validates :last_name, length: { maximum: 80 }
    validates :name, :email, length: { maximum: 100 }
    validates :document_type, inclusion: { in: GetnetApi::Customer.tipos_document_number_validos }
    validates :document_number, length: { in: 11..15 }
    validates :phone_number, length: { maximum: 15 }
    validates :observation, length: { maximum: 140 }

    validates_each [:address] do |record, attr, value|
      if value.is_a? GetnetApi::Address
        if value.invalid?
          value.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
        end
      else
        record.errors.add(attr, 'deve ser um objeto GetnetApi::Address.')
      end
    end

    # Nova instancia da classe Cliente
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Customer.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Retornar o número do tipo de phone_number no padrão utilizado pela Getnet
    def tipos_de_cliente_to_request
      TIPO_DOCUMENTO[self.document_type]
    end

    # Montar o Hash de dados do usuario no padrão utilizado pela Getnet
    def to_request tipo
      customer = {
        customer_id:      self.customer_id.to_s,
        first_name:       self.first_name.to_s,
        last_name:        self.last_name.to_s,
        email:            self.email.to_s,
        document_type:    self.tipos_de_cliente_to_request.to_s,
        document_number:  self.document_number.to_s,
        phone_number:     self.phone_number.to_s,
      }

      if tipo == :customer
          customer.merge!({"address" => address.to_request,})
      elsif tipo == :payment
          customer.merge!({"name" => self.name.to_s,})
          customer.merge!({"billing_address" => address.to_request,})
      end

      return customer
    end

    # a = GetnetApi::Customer.create cliente
    def self.create customer

      hash = customer.to_request(:customer)

      response = self.build_request self.endpoint, "post", hash

      return JSON.parse(response.read_body)
    end

    private

    def self.endpoint
      return "customers"
    end

  end
end
