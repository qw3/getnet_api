# -*- encoding : utf-8 -*-
module GetnetApi
  class Payment < Base
    require 'uri'
    require 'net/http'

    # amount
    # integer Required
    # Valor da compra em centavos.
    attr_accessor :amount

    # currency
    # string 3 characters
    # Identificação da moeda (Consultar código em "https://www.currency-iso.org/en/home/tables/table-a1.html").
    attr_accessor :currency

    # Objeto do tipo GetnetApi::Order
    attr_accessor :order

    # Objeto do tipo GetnetApi::Customer
    attr_accessor :customer

    # Validações do Rails 3
    include ActiveModel::Validations

    validates :currency, length: { maximum: 3 }

    validates_each [:order] do |record, attr, value|
      if value.is_a? GetnetApi::Order
        if value.invalid?
          value.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
        end
      else
        record.errors.add(attr, 'deve ser um objeto GetnetApi::Order.')
      end
    end

    validates_each [:customer] do |record, attr, value|
      if value.is_a? GetnetApi::Customer
        if value.invalid?
          value.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
        end
      else
        record.errors.add(attr, 'deve ser um objeto GetnetApi::Customer.')
      end
    end

    # Definir moeda usada
    def currency
      @currency ||= "BRL"
    end

    # Nova instancia da classe Cliente
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Payment.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do usuario no padrão utilizado pela Getnet
    def to_request obj, type
      payment = {
        seller_id: GetnetApi.seller_id.to_s,
        amount: amount.to_i,
        currency: currency.to_s,
        order: order.to_request,
        customer: customer.to_request(:payment)
      }

      if type == :boleto || type == :credit
        payment[:order] = order.to_request
        payment[:customer] = customer.to_request(:payment)
      end

      if type == :boleto
        payment[:boleto] = obj.to_request
      elsif type == :credit
        payment[:credit] = obj.to_request
      elsif type == :pix
        payment.merge!(obj.to_request)
      end

      payment
    end

    # a = GetnetApi::Payment.create pagamento, boleto, :boleto
    def self.create(payment, obj, type)
      hash = payment.to_request(obj, type)

      response = build_request(endpoint(type), "post", hash)

      JSON.parse(response.read_body)
    end

    def self.endpoint type
      if type == :boleto
        "payments/boleto"
      elsif type == :credit
        "payments/credit"
      elsif type == :pix
        "payments/qrcode/pix"
      end
    end
  end
end
