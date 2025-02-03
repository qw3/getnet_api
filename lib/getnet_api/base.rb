module GetnetApi
  class Base
    require "uri"
    require "net/http"

    def self.build_request endpoint, metodo, body = nil
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
      request = GetnetApi::Base.default_headers request

      request.body = body.to_json
      http.request(request)
    end

    def self.default_headers request
      request["authorization"] = "Bearer #{GetnetApi::Base.valid_bearer}"
      request["Content-Type"] = "application/json"
      request["seller_id"] = GetnetApi.seller_id.to_s
      request
    end

    def self.get_token_de_bearer
      url = URI("#{GetnetApi.endpoint}/auth/oauth/v2/token")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request.basic_auth GetnetApi.client_id.to_s, GetnetApi.client_secret.to_s
      request["Content-Type"] = "application/x-www-form-urlencoded"
      hash = {
        "scope" => "oob",
        "grant_type" => "client_credentials"
      }
      request.body = hash.to_query
      response = http.request(request)
      result = JSON.parse(response.read_body)
      GetnetApi.access_token = result["access_token"]
      GetnetApi.expires_in = DateTime.now + result["expires_in"].to_i.seconds - 60.seconds
    end

    def self.valid_bearer
      unless GetnetApi.expires_in > DateTime.now
        GetnetApi::Base.get_token_de_bearer
      end
      GetnetApi.access_token
    end
  end
end
