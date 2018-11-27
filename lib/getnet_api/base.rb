module GetnetApi
  class Base
    require 'uri'
    require 'net/http'

    def self.build_request endpoint, metodo, body=nil

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

      # body.insert(1, "\"seller_id\": \"#{GetnetApi.seller_id}\",")
      # if endpoint.to_s == ""
      # payment.merge!({"seller_id": GetnetApi.seller_id.to_s,})

      puts "BODY #{body}"

      request.body = body.to_json
      return http.request(request)
    end

    def self.default_headers request
      request["authorization"] = "Bearer #{GetnetApi::Base.valid_bearer}"
      request["Content-Type"] = "application/json"
      request["seller_id"] = "#{GetnetApi.seller_id}"
      return request
    end

    def self.get_token_de_bearer
      url = URI("#{GetnetApi.endpoint}/auth/oauth/v2/token")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request.basic_auth "#{GetnetApi.client_id}", "#{GetnetApi.client_secret}"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      hash =  {
                "scope" => 'oob',
                "grant_type" => 'client_credentials',
              }
      request.body = hash.to_query
      response =  http.request(request)
      result = JSON.parse(response.read_body)
      GetnetApi.access_token = result["access_token"]
      GetnetApi.expires_in = DateTime.now + result["expires_in"].to_i.seconds - 60.seconds
    end

    def self.valid_bearer
      if GetnetApi.expires_in > DateTime.now
        return GetnetApi.access_token
      else
        GetnetApi::Base.get_token_de_bearer
        return GetnetApi.access_token
      end
    end

  end
end
