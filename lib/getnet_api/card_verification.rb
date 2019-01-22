# -*- encoding : utf-8 -*-
module GetnetApi
  class CardVerification < Base
    require 'uri'
    require 'net/http'

    # Metodo para verificar se o token gerado é valido.
    def self.verify card

      hash =  {
              "number_token" => card.number_token.to_s,
              "cardholder_name" => card.cardholder_name.to_s,
              "expiration_month" => card.expiration_month.to_s,
              "expiration_year" => card.expiration_year.to_s,
              "security_code" => card.security_code.to_s
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

# GetnetApi::CardVerification.verify card