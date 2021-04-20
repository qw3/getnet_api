module GetnetApi
  class Base
    require 'uri'
    require 'net/http'

    def self.build_request endpoint, metodo, body=nil, auth = nil

      url = URI("#{GetnetApi.base_uri}/#{endpoint}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      case metodo
      when "delete"
        request = Net::HTTP::Delete.new(url)
      when "get"
        request = Net::HTTP::Get.new(url)
      when "put"
        request = Net::HTTP::Put.new(url)
      when "post"
        request = Net::HTTP::Post.new(url)
      end
      request = GetnetApi::Base.default_headers request, auth

      request.body = body.to_json
      return http.request(request)
    end
    def self.default_headers request, auth = nil
      request["authorization"] = "Bearer #{GetnetApi::Base.valid_bearer(auth)}"
      request["Content-Type"] = "application/json"
      seller_id = auth&.seller_id || GetnetApi.seller_id
      request["seller_id"] = "#{seller_id}"
      return request
    end

    def self.get_token_de_bearer(auth = nil)
      result = generate_access_token(auth)
      GetnetApi.access_token = result["access_token"]
      GetnetApi.expires_in = DateTime.now + result["expires_in"].to_i.seconds - 60.seconds
    end

    def self.generate_access_token(auth = nil)
      url = URI("#{GetnetApi.endpoint}/auth/oauth/v2/token")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      client_id = auth&.client_id || GetnetApi.client_id
      client_secret = auth&.client_secret || GetnetApi.client_secret
      request.basic_auth "#{client_id}", "#{client_secret}"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      hash =  {
                "scope" => 'oob',
                "grant_type" => 'client_credentials',
              }
      request.body = hash.to_query
      response = http.request(request)
      JSON.parse(response.read_body)
    end

    def self.valid_bearer(auth = nil)
      return generate_access_token(auth)['access_token'] if auth.present?

      if GetnetApi.expires_in > DateTime.now
        return GetnetApi.access_token
      else
        GetnetApi::Base.get_token_de_bearer
        return GetnetApi.access_token
      end
    end

  end
end
