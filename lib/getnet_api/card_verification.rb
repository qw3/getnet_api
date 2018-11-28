# -*- encoding : utf-8 -*-
module GetnetApi
  class CardVerification < Base
    require 'uri'
    require 'net/http'

    # Metodo para verificar se o token gerado é valido.
    def self.verify card_token

      hash =  {
              "number_token" => card_token.to_s,
              "cardholder_name": "JOAO DA SILVA",
              "expiration_month": "12",
              "expiration_year": "20",
              "security_code": "123"
              }

      response = self.build_request self.endpoint, "post", hash

      return JSON.parse(response.read_body)
    end

    private

    def self.endpoint
      return "cards/verification"
    end

  end
end

# GetnetApi::CardVerification.verify a["number_token"]