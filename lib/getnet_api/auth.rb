# frozen_string_literal: true

module GetnetApi
  class Auth < Base
    include ActiveModel::Validations

    validates :seller_id, presence: true
    validates :client_id, presence: true
    validates :client_secret, presence: true

    attr_accessor :seller_id
    attr_accessor :client_id
    attr_accessor :client_secret

    def initialize(seller_id, client_id, client_secret)
      @seller_id = seller_id
      @client_id = client_id
      @client_secret = client_secret
    end
  end
end
