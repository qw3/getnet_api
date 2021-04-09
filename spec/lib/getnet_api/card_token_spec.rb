# frozen_string_literal: true

describe GetnetApi::CardToken do
  describe '.get' do
    it 'performs the request and returns the number_token' do
      VCR.use_cassette 'getnet_api/cardtoken/get' do
        card_number = '5155901222280001'   # see https://developers.getnet.com.br/api#section/Cartoes-para-Teste
        response = GetnetApi::CardToken.get card_number
        expected_uri = 'https://api-sandbox.getnet.com.br/v1/tokens/card'
        expect(WebMock).to have_requested(:post, expected_uri)
        expect(response).to have_key("number_token")
      end
    end
  end
end
