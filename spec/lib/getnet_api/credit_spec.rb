# frozen_string_literal: true

feature GetnetApi::Credit do
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

  it 'is valid with valid attributes' do
    expect(credit).to be_valid
  end

  it 'is not valid with number token length > 128' do
    credit.number_token = '1' * 129
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:number_token]).to be_present
  end

  it 'is not valid with cardholder name length > 26' do
    credit.cardholder_name = '1' * 27
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:cardholder_name]).to be_present
  end

  it 'is not valid with security_code length > 4' do
    credit.security_code = 'A' * 5
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:security_code]).to be_present
  end

  it 'is not valid with security_code length < 3' do
    credit.security_code = 'AA'
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:security_code]).to be_present
  end

  it 'is not valid with brand length > 50' do
    credit.brand = 'A' * 51
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:brand]).to be_present
  end

  it 'is not valid with expiration month length > 2' do
    credit.expiration_month = '123'
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:expiration_month]).to be_present
  end

  it 'is not valid with expiration year length > 2' do
    credit.expiration_year = '123'
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:expiration_year]).to be_present
  end

  context '#to_request' do
    it 'returns credit object as a hash' do
      credit_hash = credit.to_request
      credit_hash.keys.each do |key|
        expect(credit_hash[key]).to eq credit.send(key)
      end
    end
  end
end
