# frozen_string_literal: true

describe GetnetApi::Payment do
  let(:boleto) do
    GetnetApi::Boleto.new(
      our_number: '123321123',
      document_number: '12345678',
      instructions: 'Não receber após o vencimento',
      provider: 'santander'
    )
  end

  let(:card_token) do
    token = ''
    VCR.use_cassette('getnet_api/cardtoken/get') do
      card_number = '5155901222280001' # see https://developers.getnet.com.br/api#section/Cartoes-para-Teste
      token = GetnetApi::CardToken.get(card_number)['number_token']
    end
  end

  let(:card) do
    GetnetApi::Card.new(
      number_token: card_token,
      cardholder_name: 'JOAO DA SILVA',
      security_code: '123',
      brand: 'Mastercard',
      expiration_month: '12',
      expiration_year: '23'
    )
  end

  let(:credit) do
    GetnetApi::Credit.new(
      delayed: false,
      authenticated: false,
      pre_authorization: false,
      save_card_data: false,
      transaction_type: 'FULL',
      number_installments: 1,
      soft_descriptor: 'Descrição para fatura',
      dynamic_mcc: 1799,
      card: card
    )
  end

  let(:address) do
    GetnetApi::Address.new(
      street: 'Nome da Rua',
      number: '123',
      complement: 'Complemento',
      district: 'Nome do Bairro',
      city: 'São Paulo',
      state: 'SP',
      country: 'Brasil',
      postal_code: '01010010'
    )
  end

  let(:customer) do
    GetnetApi::Customer.new(
      customer_id: '123',
      first_name: 'João',
      last_name: 'da Silva',
      name: 'João da Silva',
      email: 'joao@email.com',
      document_type: :pessoa_fisica,
      document_number: '12332112340',
      address: address,
      phone_number: '5551999887766',
      celphone_number: '5551999887766',
      observation: 'O cliente tem interesse no plano x.'
    )
  end

  let(:order) do
    GetnetApi::Order.new(
      order_id: '123',
      sales_tax: 0,
      product_type: 'service'
    )
  end

  let(:payment) do
    GetnetApi::Payment.new(
      amount: 10_000,
      currency: 'BRL',
      order: order,
      customer: customer
    )
  end

  it 'is valid with valid attributes' do
    expect(payment).to be_valid
  end

  it 'is not valid with currency length > 3' do
    payment.currency = 'ABCD'
    expect(payment).not_to be_valid
    expect(payment.errors.messages[:currency]).to be_present
  end

  it 'is not valid with order not being the correct object' do
    payment.order = Object.new
    expect(payment).not_to be_valid
    expect(payment.errors.messages[:order]).to be_present
  end

  it 'is not valid with invalid order' do
    payment.order.order_id = '1' * 37
    expect(payment).not_to be_valid
    expect(payment.errors.messages[:order]).to be_present
  end

  it 'is not valid with customer not being the correct object' do
    payment.customer = Object.new
    expect(payment).not_to be_valid
    expect(payment.errors.messages[:customer]).to be_present
  end

  it 'is not valid with invalid customer' do
    payment.customer.customer_id = '1' * 101
    expect(payment).not_to be_valid
    expect(payment.errors.messages[:customer]).to be_present
  end

  context '#to_request' do
    it 'returns payment object as a hash' do
      payment_hash = payment.to_request(credit, :credit)
      hash_keys = payment_hash.keys.reject do |key|
        %i[order customer credit seller_id].include?(key)
      end

      hash_keys.each do |key|
        expect(payment_hash[key]).to eq payment.send(key)
      end

      expect(payment_hash[:order]).to eq payment.order.to_request
      expect(payment_hash[:customer]).to eq payment.customer.to_request(:payment)
      expect(payment_hash[:credit]).to eq credit.to_request
      expect(payment_hash[:seller_id]).to eq GetnetApi.seller_id.to_s
    end
  end

  context '.create' do
    context 'when paying by boleto', :vcr do
      it 'correctly requests for boleto payment' do
        response = GetnetApi::Payment.create payment, boleto, :boleto
        expected_uri = 'https://api-sandbox.getnet.com.br/v1/payments/boleto'
        expect(WebMock).to have_requested(:post, expected_uri)
        expect(response).to have_key('boleto')
      end
    end

    context 'when paying by credit', :vcr do
      it 'correctly requests for credit payment' do
        response = GetnetApi::Payment.create payment, credit, :credit
        expected_uri = 'https://api-sandbox.getnet.com.br/v1/payments/credit'
        expect(WebMock).to have_requested(:post, expected_uri)
        expect(response).to have_key('credit')
      end
    end
  end
end
