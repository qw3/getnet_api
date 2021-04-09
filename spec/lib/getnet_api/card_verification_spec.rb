# frozen_string_literal: true

describe GetnetApi::CardVerification do
  describe '.verify', :vcr do
    let(:card_token) do
      card_number = '5155901222280001' # see https://developers.getnet.com.br/api#section/Cartoes-para-Teste
      GetnetApi::CardToken.get(card_number)['number_token']
    end

    let(:card) do
      GetnetApi::Card.new(
        number_token: card_token,
        cardholder_name: 'JOAO DA SILVA',
        security_code: '123',
        brand: 'Mastercard',
        expiration_month: '12',
        expiration_year: '20'
      )
    end

    it 'performs the request and returns the verification result' do
      response = GetnetApi::CardVerification.verify card
      expected_uri = 'https://api-sandbox.getnet.com.br/v1/cards/verification'
      expect(WebMock).to have_requested(:post, expected_uri)
      expect(response['status']).to eq 'VERIFIED'
      expect(response).to have_key 'verification_id'
      expect(response).to have_key 'authorization_code'
    end
  end
end
