# -*- encoding : utf-8 -*-
module GetnetApi
  class Credit < Base

    # Boolean Required
    # Identifica se o crédito será feito com confirmação tardia.
    attr_accessor :delayed

    # Boolean
    # Indicativo se transação deve ter o processo de autenticação no emissor, caso authenticated = true, o portador deve ser encaminhado ao site do emissor para autenticação junto ao mesmo.
    attr_accessor :authenticated

    # Boolean
    # Indicativo se a transação é uma pré autorização de crédito.
    attr_accessor :pre_authorization

    # Boolean Required
    # Identifica se o cartão deve ser salvo para futuras compras.
    attr_accessor :save_card_data

    # string Required
    # "FULL" "INSTALL_NO_INTEREST" "INSTALL_WITH_INTEREST"
    # Tipo de transação. Pagamento completo à vista, parcelado sem juros, parcelado com juros.
    attr_accessor :transaction_type

    # integer Required
    # Número de parcelas.
    attr_accessor :number_installments

    # string <= 22 characters
    # Texto exibido na fatura do cartão do comprador, Este campo é opcional, não sendo informado nada, será considerado o nome fantasia cadastrado para o estabelecimento.
    attr_accessor :soft_descriptor

    # integer
    # Campo utilizado para sinalizar a transação com outro Merchant Category Code (Código da Categoria do Estabelecimento) diferente do cadastrado. Caso seja enviado um MCC inválido, será utilizado o padrão. Enviar somente dados numéricos.
    attr_accessor :dynamic_mcc

    # Cartão
    # GetnetApi::Card
    attr_accessor :card

    # Validações do Rails 3
    include ActiveModel::Validations

    validates :transaction_type, length: { maximum: 22 }
    validates :number_installments, presence: true
    validates :soft_descriptor, length: { maximum: 22 }
    validates :dynamic_mcc, length: { maximum: 10 }

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