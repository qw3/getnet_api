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

    # Validações do Rails 3
    include ActiveModel::Validations

    validates :cancel_amount, length: { maximum: 10 }

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
      }
    end

    # a = GetnetApi::PaymentCancel.create cancelamento_pagamento
    def self.create payment_cancel
      hash = payment_cancel.to_request

      response = self.build_request self.endpoint(hash[:payment_id]), "post", hash

      return JSON.parse(response.read_body)
    end

    private
      def self.endpoint payment_id
        "payments/credit/#{payment_id}/cancel"
      end
  end
end
