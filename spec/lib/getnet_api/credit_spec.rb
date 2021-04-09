# frozen_string_literal: true

describe GetnetApi::Credit do
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

  it 'is not valid with transaction type length > 22' do
    credit.transaction_type = 'A' * 23
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:transaction_type]).to be_present
  end

  it 'is not valid without number installments' do
    credit.number_installments = nil
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:number_installments]).to be_present
  end

  it 'is not valid with soft descriptor length > 22' do
    credit.soft_descriptor = 'A' * 23
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:soft_descriptor]).to be_present
  end

  it 'is not valid with dynamic mcc length > 10' do
    credit.dynamic_mcc = 'A' * 11
    expect(credit).not_to be_valid
    expect(credit.errors.messages[:dynamic_mcc]).to be_present
  end

  context '#to_request' do
    it 'returns credit object as a hash' do
      credit_hash = credit.to_request
      hash_keys = credit_hash.keys.reject { |k| k == :card }
      hash_keys.each do |key|
        expect(credit_hash[key]).to eq credit.send(key)
      end

      expect(credit_hash[:card]).to eq credit.card.to_request
    end
  end
end
