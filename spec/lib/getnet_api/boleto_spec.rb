# frozen_string_literal: true

describe GetnetApi::Boleto do
  let(:boleto) do
    GetnetApi::Boleto.new(
      our_number: '123321123',
      document_number: '12345678',
      instructions: 'Não receber após o vencimento',
      provider: 'santander'
    )
  end

  it 'is valid with valid attributes' do
    expect(boleto).to be_valid
  end

  it 'is not valid with our number length > 12' do
    boleto.our_number = '1' * 13
    expect(boleto).not_to be_valid
    expect(boleto.errors.messages[:our_number]).to be_present
  end

  it 'is not valid with document number length > 15' do
    boleto.document_number = '1' * 16
    expect(boleto).not_to be_valid
    expect(boleto.errors.messages[:document_number]).to be_present
  end

  it 'is not valid with instructions length > 1000' do
    boleto.instructions = 'A' * 1001
    expect(boleto).not_to be_valid
    expect(boleto.errors.messages[:instructions]).to be_present
  end

  it 'is not valid with provider length > 40' do
    boleto.provider = 'A' * 41
    expect(boleto).not_to be_valid
    expect(boleto.errors.messages[:provider]).to be_present
  end

  context '#to_request' do
    it 'returns boleto object as a hash' do
      boleto_hash = boleto.to_request
      boleto_hash.keys.each do |key|
        expect(boleto_hash[key]).to eq boleto.send(key)
      end
    end
  end
end
