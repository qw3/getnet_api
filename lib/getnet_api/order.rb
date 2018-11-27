# -*- encoding : utf-8 -*-
module GetnetApi
  class Order

    # Conjunto de dados para identificação da compra
    # order_id
    # string <= 36 characters Required
    attr_accessor :order_id

    # Código de identificação da compra utilizado pelo e-commerce
    # Valor de impostos
    attr_accessor :sales_tax

    # string
    # "cash_carry" "digital_content" "digital_goods" "digital_physical" "gift_card" "phisical_goods" "renew_subs" "shareware" "service"
    # Identificador do tipo de produto vendido dentre as opções
    attr_accessor :product_type

    # Validações do Rails 3
    include ActiveModel::Validations

    # validates :valor_total, length: { maximum:  }
    # validates :expiration_date, length: { maximum:  }
    validates :order_id, length: { maximum: 36 }
    # validates :sales_tax , length: {  }
    # validates :product_type, length: {  }

    # Nova instancia da classe Boleto
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Order.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do pagamento no padrão utilizado pela Getnet
    def to_request
        order = {
          order_id:      self.order_id.to_s,
          sales_tax:     self.sales_tax.to_i,
          product_type:  self.product_type.to_s
        }

      return order
    end

  end
end
