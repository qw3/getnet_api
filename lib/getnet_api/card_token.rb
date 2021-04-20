# -*- encoding : utf-8 -*-
module GetnetApi
  class CardToken < Base
    require 'uri'
    require 'net/http'

    # Metodo para gerar o token do cartão de credito do cliente, para ser usado no pagamento.
    def self.get card_number, auth = nil

      hash =  {
              "card_number" => card_number.to_s
              }

      response = self.build_request self.endpoint, "post", hash, auth

      return JSON.parse(response.read_body)
    end

    private

    def self.endpoint
      return "tokens/card"
    end

  end
end

# GetnetApi::CardToken.get "5155901222280001"