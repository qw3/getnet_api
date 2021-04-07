# frozen_string_literal: true

describe GetnetApi::Configure do
  describe '#configure' do
    before do
      GetnetApi.configure do |config|
        config.ambiente = :sandbox
        config.seller_id = 'seller_id'
        config.client_id = 'client_id'
        config.client_secret = 'client_secret'
      end
    end

    it 'sets attributes to GetnetApi' do
      expect(GetnetApi.seller_id).to eq 'seller_id'
      expect(GetnetApi.client_id).to eq 'client_id'
      expect(GetnetApi.client_secret).to eq 'client_secret'
    end
  end

  describe '#endpoint' do
    it 'sets and returns endpoint based on ambiente' do
      ambiente = GetnetApi.ambiente
      expected_endpoint = GetnetApi::Configure::URL[ambiente]
      expect(GetnetApi.endpoint).to eq expected_endpoint
    end
  end

  describe '#set_endpoint' do
    context 'when ambiente is producao' do
      it 'returns endpoint for producao' do
        GetnetApi.ambiente = :producao
        expected_endpoint = GetnetApi::Configure::URL[:producao]
        expect(GetnetApi.set_endpoint).to eq expected_endpoint
      end
    end

    context 'when ambiente is homologacao' do
      it 'returns endpoint for homologacao' do
        GetnetApi.ambiente = :homologacao
        expected_endpoint = GetnetApi::Configure::URL[:homologacao]
        expect(GetnetApi.set_endpoint).to eq expected_endpoint
      end
    end

    context 'when ambiente is sandbox' do
      it 'returns endpoint for sandbox' do
        GetnetApi.ambiente = :sandbox
        expected_endpoint = GetnetApi::Configure::URL[:sandbox]
        expect(GetnetApi.set_endpoint).to eq expected_endpoint
      end
    end
  end

  describe '#base_uri' do
    it 'returnes uri based on endpoint and api version' do
      expected_endpoint = "#{GetnetApi.endpoint}/#{GetnetApi.api_version}"
      expect(GetnetApi.base_uri).to eq expected_endpoint
    end
  end
end
