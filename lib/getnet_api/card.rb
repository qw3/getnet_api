# -*- encoding : utf-8 -*-
module GetnetApi
  class Card

    attr_accessor :number_token
    attr_accessor :cardholder_name
    attr_accessor :security_code
    attr_accessor :brand
    attr_accessor :expiration_month
    attr_accessor :expiration_year

    # Validações do Rails 3
    include ActiveModel::Validations

    validates :number_token, length: { maximum: 128 }
    validates :cardholder_name, length: { maximum: 26 }
    validates :security_code, length: { in: 3..4 }
    validates :brand, length: { maximum: 50 }
    validates :expiration_month, length: { maximum: 2 }
    validates :expiration_year, length: { maximum: 2 }

    # Nova instancia da classe Card
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Card.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do pagamento no padrão utilizado pela Getnet
    def to_request
        card = {
          number_token:       self.number_token,
          cardholder_name:    self.cardholder_name,
          security_code:      self.security_code,
          brand:              self.brand,
          expiration_month:   self.expiration_month,
          expiration_year:    self.expiration_year
        }

      return card
    end

  end
end
