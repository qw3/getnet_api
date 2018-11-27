# -*- encoding : utf-8 -*-
module GetnetApi
  class Boleto

    # string 12 characters
    # Denominado pelos bancos como "Nosso Número". É a identificação única do boleto no sistema de cobrança. É composto por regras que variam em função do banco e do serviço de cobrança. Por exemplo, no caso do Santander existem duas formas de se numerar. 1) Se cliente quem numera, deve informar o dígito verificador (DV); 2) Se o cliente omitir o número, o Banco fica encarregado da geração de um sequêncial, sem um DV. (sem máscara)
    attr_accessor :our_number

    # string 15 characters
    # Seu Número. Número controlado pelo cliente, geralmente é gerenciado pelo sistema que está gerando o boleto. (sem máscara)
    attr_accessor :document_number

    # string <dd/mm/yyyy>
    # Data do vencimento do boleto. Caso não seja informado, será considerado o número de dias padrão pré-cadastrado para o vencimento.
    attr_accessor :expiration_date

    # string
    # Instruções a serem impressas no boleto (colocar quebra de linha a cada 100 caracteres, máximo 10 linhas).
    attr_accessor :instructions

    # string <= 40 characters
    # Banco provedor. "santander"
    attr_accessor :provider

    # Validações do Rails 3
    include ActiveModel::Validations

    # validates :valor_total, length: { maximum:  }
    # validates :expiration_date, length: { maximum:  }
    validates :moeda, length: { maximum: 3 }
    validates :our_number , length: { maximum: 12 }
    validates :document_number, length: { maximum: 15 }
    validates :instructions, length: { maximum: 1000 }
    validates :provider, length: { maximum: 40 }

    # Nova instancia da classe Boleto
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Boleto.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do pagamento no padrão utilizado pela Getnet
    def to_request
        boleto = {
          our_number:       self.our_number,
          document_number:  self.document_number,
          expiration_date:  self.expiration_date,
          instructions:     self.instructions,
          provider:         self.provider
        }

      return boleto
    end

  end
end
