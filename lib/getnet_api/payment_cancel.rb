module GetnetApi
  class PaymentCancel < Base
    # payment_id
    # string <= 36 characters Required
    # ID do pagamento via cartão de crédito
    attr_accessor :payment_id

    # cancel_amount
    # interger Required
    # Valor do pagamento em centavos
    attr_accessor :cancel_amount

    # cancel_custom_key
    # string <= 32 characters
    # Chave do cliente utilizada para identificar uma solicitação de cancelamento.
    attr_accessor :cancel_custom_key

    # Validações do Rails 3
    include ActiveModel::Validations

    validates :amount, length: { maximum: 3 }

    def initialize campos={}
      campos.each do |campo, valor|
        if GetnetApi::PaymentCancel.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do usuario no padrão utilizado pela Getnet
    def to_request
      pay_cancel = {
        payment_id: self.payment_id,
        cancel_amount: self.cancel_amount,
        cancel_custom_key: self.cancel_custom_key
      }
    end

    # a = GetnetApi::PaymentCancel.create cancelamento_pagamento
    def self.create payment_cancel
      hash = payment_cancel.to_request

      response = self.build_request self.endpoint, "post", hash

      return JSON.parse(response.read_body)
    end

    private
      def self.endpoint
        "cancel/request"
      end
  end
end