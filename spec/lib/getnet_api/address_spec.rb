# frozen_string_literal: true

describe GetnetApi::Address do
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

  it 'is valid with valid attributes' do
    expect(address).to be_valid
  end

  it 'is not valid with street length > 60' do
    address.street = 'A' * 61
    expect(address).not_to be_valid
    expect(address.errors.messages[:street]).to be_present
  end

  it 'is not valid with number length > 10' do
    address.number = '1' * 11
    expect(address).not_to be_valid
    expect(address.errors.messages[:number]).to be_present
  end

  it 'is not valid with complement length > 60' do
    address.complement = 'A' * 61
    expect(address).not_to be_valid
    expect(address.errors.messages[:complement]).to be_present
  end

  it 'is not valid with district length > 40' do
    address.district = 'A' * 41
    expect(address).not_to be_valid
    expect(address.errors.messages[:district]).to be_present
  end

  it 'is not valid with city length > 40' do
    address.city = 'A' * 41
    expect(address).not_to be_valid
    expect(address.errors.messages[:city]).to be_present
  end

  it 'is not valid with state length > 20' do
    address.state = 'A' * 21
    expect(address).not_to be_valid
    expect(address.errors.messages[:state]).to be_present
  end

  it 'is not valid with country length > 20' do
    address.country = 'A' * 21
    expect(address).not_to be_valid
    expect(address.errors.messages[:country]).to be_present
  end

  it 'is not valid with postal code length > 8' do
    address.postal_code = '1' * 9
    expect(address).not_to be_valid
    expect(address.errors.messages[:postal_code]).to be_present
  end

  context '#to_request' do
    it 'returns address object as a hash' do
      address_hash = address.to_request
      address_hash.keys.each do |key|
        expect(address_hash[key]).to eq address.send(key)
      end
    end
  end
end
