# frozen_string_literal: true

describe GetnetApi::Card do
  let(:card) do
    GetnetApi::Card.new(
      number_token: 'dfe05208b105578c070f806c80abd3af09e246827d29b866cf4ce16c205849977c9496cbf0d0234f42339937f327747075f68763537b90b31389e01231d4d13c',
      cardholder_name: 'JOAO DA SILVA',
      security_code: '123',
      brand: 'Mastercard',
      expiration_month: '12',
      expiration_year: '20'
    )
  end

  it 'is valid with valid attributes' do
    expect(card).to be_valid
  end

  it 'is not valid with number token length > 128' do
    card.number_token = '1' * 129
    expect(card).not_to be_valid
    expect(card.errors.messages[:number_token]).to be_present
  end

  it 'is not valid with cardholder name length > 26' do
    card.cardholder_name = '1' * 27
    expect(card).not_to be_valid
    expect(card.errors.messages[:cardholder_name]).to be_present
  end

  it 'is not valid with security_code length > 4' do
    card.security_code = 'A' * 5
    expect(card).not_to be_valid
    expect(card.errors.messages[:security_code]).to be_present
  end

  it 'is not valid with security_code length < 3' do
    card.security_code = 'AA'
    expect(card).not_to be_valid
    expect(card.errors.messages[:security_code]).to be_present
  end

  it 'is not valid with brand length > 50' do
    card.brand = 'A' * 51
    expect(card).not_to be_valid
    expect(card.errors.messages[:brand]).to be_present
  end

  it 'is not valid with expiration month length > 2' do
    card.expiration_month = '123'
    expect(card).not_to be_valid
    expect(card.errors.messages[:expiration_month]).to be_present
  end

  it 'is not valid with expiration year length > 2' do
    card.expiration_year = '123'
    expect(card).not_to be_valid
    expect(card.errors.messages[:expiration_year]).to be_present
  end

  context '#to_request' do
    it 'returns card object as a hash' do
      card_hash = card.to_request
      card_hash.keys.each do |key|
        expect(card_hash[key]).to eq card.send(key)
      end
    end
  end
end
