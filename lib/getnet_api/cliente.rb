# -*- encoding : utf-8 -*-
module GetnetApi
  class Cliente

    # Opções de Tipo de Cliente
    TIPO_DOCUMENTO = {
      :pessoa_fisica    => "CPF",
      :pessoa_juridica  => "CNPJ",
    }

    # Código que identifica o cliente no estabelecimento.
    # Alfa Numérico - Até 20 caracteres
    attr_accessor :codigo_cliente

    # Nome do comprador
    # Alfa Numérico - Até 40 caracteres
    attr_accessor :primeiro_nome

    # Nome do comprador
    # Alfa Numérico - Até 80 caracteres
    attr_accessor :ultimo_nome

    # Nome do comprador
    # Alfa Numérico - Até 100 caracteres
    attr_accessor :nome_completo

    # E-mail do comprador
    # Alfa Numérico - Até 100 caracteres
    attr_accessor :email

    # Identifica o tipo de documento informado é pessoa física ou jurídica.
    # Simbolo - Valores pré-definidos [:pessoa_fisica, :pessoa_juridica]
    attr_accessor :tipo_documento

    # Número do documento do comprador sem pontuação. (sem máscara)
    # Alfa Numérico - Até 15 caracteres
    attr_accessor :documento

    # Endereços
    # GetnetApi::Endereco
    attr_accessor :endereco

    # Telefone do comprador. (sem máscara)
    # Alfa Numérico - Até 15 caracteres
    attr_accessor :telefone

    # Validações do Rails 3
    include ActiveModel::Validations

    # Retornar array com os possíveis tipos de cliente
    def self.tipos_documento_validos
      TIPO_DOCUMENTO.map{ |key, value| key }
    end

    # Validações
    validates :codigo_cliente, length: { maximum: 100 }
    validates :primeiro_nome, length: { maximum: 40 }
    validates :ultimo_nome, length: { maximum: 80 }
    validates :nome_completo, :email, length: { maximum: 100 }
    validates :tipo_documento, inclusion: { in: GetnetApi::Cliente.tipos_documento_validos }
    validates :documento, length: { in: 11..15 }
    validates :telefone, length: { maximum: 15 }

    validates_each [:endereco] do |record, attr, value|
      if value.is_a? GetnetApi::Endereco
        if value.invalid?
          value.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
        end
      else
        record.errors.add(attr, 'deve ser um objeto GetnetApi::Endereco.')
      end
    end

    # Nova instancia da classe Cliente
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Cliente.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Retornar o número do tipo de telefone no padrão utilizado pela Getnet
    def tipos_de_cliente_to_request
      TIPO_DOCUMENTO[self.tipo_documento]
    end

    # Montar o Hash de dados do usuario no padrão utilizado pela Getnet
    def to_request
      cliente = {
        customer_id:      self.codigo_cliente,
        first_name:       self.primeiro_nome,
        last_name:        self.ultimo_nome,
        name:             self.nome_completo,
        email:            self.email,
        document_type:    self.tipos_de_cliente_to_request,
        document_number:  self.documento,
        phone_number:     self.telefone,
        billing_address:  self.endereco.to_request,
      }

      return cliente
    end

  end
end
