# -*- encoding : utf-8 -*-
module GetnetApi
  class Credit < Base

    attr_accessor :delayed

    attr_accessor :authenticated

    attr_accessor :pre_authorization

    attr_accessor :save_card_data

    # string Required
    # "FULL" "INSTALL_NO_INTEREST" "INSTALL_WITH_INTEREST"
    # Tipo de transação. Pagamento completo à vista, parcelado sem juros, parcelado com juros.
    attr_accessor :transaction_type

   # integer Required
   # Número de parcelas.
    attr_accessor :number_installments

    attr_accessor :soft_descriptor

    # integer
    # Campo utilizado para sinalizar a transação com outro Merchant Category Code (Código da Categoria do Estabelecimento) diferente do cadastrado. Caso seja enviado um MCC inválido, será utilizado o padrão. Enviar somente dados numéricos.
    attr_accessor :dynamic_mcc

    # Cartão
    # GetnetApi::Card
    attr_accessor :card

    # Validações do Rails 3
    include ActiveModel::Validations

    # validates :delayed, length: {  } boolean
    # validates :authenticated, length: {  } boolean
    # validates :pre_authorization, length: {  } boolean
    # validates :save_card_data, length: {  } boolean
    validates :transaction_type, length: { maximum: 22 }
    validates :number_installments, presence: true
    validates :soft_descriptor, length: { maximum: 22 }#, allow: :blank
    validates :dynamic_mcc, length: { maximum: 10 }#, allow: :blank

    validates_each [:card] do |record, attr, value|
      if value.is_a? GetnetApi::Card
        if value.invalid?
          value.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
        end
      else
        record.errors.add(attr, 'deve ser um objeto GetnetApi::Card.')
      end
    end

    # Nova instancia da classe Credit
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Credit.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do pagamento no padrão utilizado pela Getnet
    def to_request
        credit = {
          delayed:              self.delayed,
          authenticated:        self.authenticated,
          pre_authorization:    self.pre_authorization,
          save_card_data:       self.save_card_data,
          transaction_type:     self.transaction_type,
          number_installments:  self.number_installments.to_i,
          soft_descriptor:      self.soft_descriptor,
          dynamic_mcc:          self.dynamic_mcc,
          card:                 self.card.to_request,
        }

      return credit
    end

  end
end