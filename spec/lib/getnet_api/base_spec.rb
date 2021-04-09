# frozen_string_literal: true

describe GetnetApi::Base do
  describe '.build_request', :vcr do
    it 'builds and executes request based on' do
      GetnetApi.ambiente = :sandbox
      response = GetnetApi::Base.build_request 'some_endpoint', 'get'
      expect(response).to be_a Net::HTTPNotFound
      expected_uri = 'https://api-sandbox.getnet.com.br/v1/some_endpoint'
      expect(WebMock).to have_requested(:get, expected_uri)
    end
  end

  describe '.default_headers' do
    let(:dummy_url) { 'someurl.com' }
    let(:dummy_request) { Net::HTTP::Get.new(dummy_url) }
    it 'creates headers for request' do
      VCR.use_cassette 'getnet_api/base/valid_bearer' do
        request = GetnetApi::Base.default_headers dummy_request
        expected_auth = "Bearer #{GetnetApi::Base.valid_bearer}"
        expect(request['authorization']).to eq expected_auth
        expect(request['Content-Type']).to eq 'application/json'
        expect(request['seller_id']).to eq GetnetApi.seller_id
      end
    end
  end

  describe '.valid_bearer' do
    context 'when token is expired' do
      it 'requests for new access token' do
        VCR.use_cassette 'getnet_api/base/valid_bearer' do
          GetnetApi.expires_in = nil
          expect(GetnetApi::Base.valid_bearer).to be_present
          expect(GetnetApi.expires_in).to be_present
          expect(GetnetApi.expires_in > DateTime.current).to be true
        end
      end
    end

    context 'when token is not expired' do
      it 'returnes current token' do
        GetnetApi.access_token = 'some_token'
        GetnetApi.expires_in = DateTime.current + 1.day
        expect(GetnetApi::Base.valid_bearer).to be_present
        expect(GetnetApi::Base.valid_bearer).to eq 'some_token'
      end
    end
  end

  describe '.get_token_de_bearer' do
    context 'when token is expired' do
      it 'creates requests for new access token' do
        VCR.use_cassette 'getnet_api/base/valid_bearer' do
          GetnetApi.expires_in = nil
          GetnetApi::Base.get_token_de_bearer
          expect(GetnetApi::Base.valid_bearer).to be_present
          expect(GetnetApi.expires_in).to be_present
          expect(GetnetApi.expires_in).to be > DateTime.current
        end
      end
    end
  end
end
