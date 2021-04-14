# frozen_string_literal: true

describe GetnetApi::Payment do

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
      amount: 100,
      currency: 'BRL',
      order: order,
      customer: customer
    )
  end

  let(:payment_cancel) do
    GetnetApi::PaymentCancel.new(
       payment_id: "79447fe6-8672-4187-85de-11c4bab37aab",
       cancel_amount: 100
    )
  end
  
  it 'is valid with valid attributes' do
    expect(payment_cancel).to be_valid
  end


  context '#to_request' do
    it 'returns card object as a hash' do
      payment_cancel_hash = payment_cancel.to_request
      payment_cancel_hash.keys.each do |key|
        expect(payment_cancel_hash[key]).to eq payment_cancel.send(key)
      end
    end
  end

  context '.create' do
    context 'when cancelling a payment', :vcr do
      it 'correctly execute the request' do
        response = GetnetApi::Payment.create payment, credit, :credit
        payment_id = response['payment_id']
        payment_cancel = GetnetApi::PaymentCancel.new(
           payment_id: payment_id,
           cancel_amount: 100
        )
        VCR.use_cassette('getnet_api/payment_cancel/create') do
           response_cancelamento = GetnetApi::PaymentCancel.create payment_cancel
        end   
        expected_uri = "https://api-sandbox.getnet.com.br/v1/payments/credit/#{payment_id}/cancel"
        expect(WebMock).to have_requested(:post, expected_uri)
      end
    end  
  end
end
