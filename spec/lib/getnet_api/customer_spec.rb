# frozen_string_literal: true

describe GetnetApi::Customer do
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

  it 'is valid with valid attributes' do
    expect(customer).to be_valid
  end

  it 'is not valid with customer id length > 100' do
    customer.customer_id = '1' * 101
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:customer_id]).to be_present
  end

  it 'is not valid with first name length > 40' do
    customer.first_name = 'A' * 41
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:first_name]).to be_present
  end

  it 'is not valid with last name length > 80' do
    customer.last_name = 'A' * 81
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:last_name]).to be_present
  end

  it 'is not valid with name length > 100' do
    customer.name = 'A' * 101
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:name]).to be_present
  end

  it 'is not valid with email length > 100' do
    customer.email = 'A' * 101
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:email]).to be_present
  end

  it 'is not valid with document number length > 15' do
    customer.document_number = '1' * 16
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:document_number]).to be_present
  end

  it 'is not valid with document number length < 11' do
    customer.document_number = '1' * 10
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:document_number]).to be_present
  end

  it 'is not valid with phone number length > 15' do
    customer.phone_number = '1' * 16
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:phone_number]).to be_present
  end

  it 'is not valid with observation length > 140' do
    customer.observation = '1' * 141
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:observation]).to be_present
  end

  it 'is not valid with address not being the correct object' do
    customer.address = Object.new
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:address]).to be_present
  end

  it 'is not valid with invalid address' do
    customer.address.street = 'A' * 61
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:address]).to be_present
  end

  it 'is not valid with document type with invalid key' do
    customer.document_type = :invalid
    expect(customer).not_to be_valid
    expect(customer.errors.messages[:document_type]).to be_present
  end

  context '#to_request' do
    it 'returns customer object as a hash' do
      customer_hash = customer.to_request(:payment)
      hash_keys = customer_hash.keys.reject do |key|
        ['billing_address', :document_type].include?(key)
      end
      hash_keys.each do |key|
        expect(customer_hash[key]).to eq customer.send(key)
      end
      expect(customer_hash['billing_address']).to eq customer.address.to_request
      expect(customer_hash[:document_type]).to eq 'CPF'
    end
  end

  describe '.create', :vcr do
    it 'performs the request and returns the number_token' do
      GetnetApi::Customer.create customer
      expected_uri = 'https://api-sandbox.getnet.com.br/v1/customers'
      expect(WebMock).to have_requested(:post, expected_uri)
    end
  end
end
