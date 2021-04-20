# frozen_string_literal: true

describe GetnetApi::CardToken do
  describe '.get' do
    context 'when using external authentication keys' do
      let(:auth) do
        GetnetApi::Auth.new(
          '41ecaef6-cf9e-4efe-96c0-e29db363c9b8',
          '007d27d7-3280-4529-b428-e568849da4b6',
          'd989c95c-6bd0-4e1c-a030-82b0a906afb1'
        )
      end

      it 'performs the request with correct seller id', :vcr do
        card_number = '5155901222280001'   # see https://developers.getnet.com.br/api#section/Cartoes-para-Teste
        response = GetnetApi::CardToken.get card_number, auth
        expected_uri = 'https://api-sandbox.getnet.com.br/v1/tokens/card'
        expect(WebMock).to have_requested(:post, expected_uri)
          .with(headers: { 'Seller-Id' => auth.seller_id })
        expect(response).to have_key('number_token')
      end
    end

    it 'performs the request and returns the number_token' do
      VCR.use_cassette 'getnet_api/cardtoken/get' do
        card_number = '5155901222280001'   # see https://developers.getnet.com.br/api#section/Cartoes-para-Teste
        response = GetnetApi::CardToken.get card_number
        expected_uri = 'https://api-sandbox.getnet.com.br/v1/tokens/card'
        expect(WebMock).to have_requested(:post, expected_uri)
        expect(response).to have_key('number_token')
      end
    end
  end
end
