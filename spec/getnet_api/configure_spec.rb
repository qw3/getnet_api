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

  describe '#ambiente' do
    it 'sets and returns default value' do
      expect(GetnetApi.ambiente).to eq GetnetApi::Configure::AMBIENTE
      instance_ambiente = GetnetApi.instance_variable_get(:@ambiente)
      expect(instance_ambiente).to eq GetnetApi::Configure::AMBIENTE
    end
  end

  describe '#ambiente=' do
    it 'correctly sets value' do
      GetnetApi.ambiente = :producao
      expect(GetnetApi.ambiente).to eq :producao
      instance_ambiente = GetnetApi.instance_variable_get(:@ambiente)
      expect(instance_ambiente).to eq :producao
    end
  end

  describe '#api_version' do
    it 'sets and returns default value' do
      expect(GetnetApi.api_version).to eq GetnetApi::Configure::API_VERSION
      instance_api_version = GetnetApi.instance_variable_get(:@api_version)
      expect(instance_api_version).to eq GetnetApi::Configure::API_VERSION
    end
  end

  describe '#api_version=' do
    it 'correctly sets value' do
      GetnetApi.api_version = 'v2'
      expect(GetnetApi.api_version).to eq 'v2'
      instance_api_version = GetnetApi.instance_variable_get(:@api_version)
      expect(instance_api_version).to eq 'v2'
    end
  end

  describe '#seller_id' do
    it 'sets and returns default value' do
      GetnetApi.seller_id = nil
      expect(GetnetApi.seller_id).to eq GetnetApi::Configure::SELLER_ID
      instance_seller_id = GetnetApi.instance_variable_get(:@seller_id)
      expect(instance_seller_id).to eq GetnetApi::Configure::SELLER_ID
    end
  end

  describe '#seller_id=' do
    it 'correctly sets value' do
      GetnetApi.seller_id = 'new_seller_id'
      expect(GetnetApi.seller_id).to eq 'new_seller_id'
      instance_seller_id = GetnetApi.instance_variable_get(:@seller_id)
      expect(instance_seller_id).to eq 'new_seller_id'
    end
  end

  describe '#client_id' do
    it 'sets and returns default value' do
      GetnetApi.client_id = nil
      expect(GetnetApi.client_id).to eq GetnetApi::Configure::CLIENT_ID
      instance_client_id = GetnetApi.instance_variable_get(:@client_id)
      expect(instance_client_id).to eq GetnetApi::Configure::CLIENT_ID
    end
  end

  describe '#client_id=' do
    it 'correctly sets value' do
      GetnetApi.client_id = 'new_client_id'
      expect(GetnetApi.client_id).to eq 'new_client_id'
      instance_client_id = GetnetApi.instance_variable_get(:@client_id)
      expect(instance_client_id).to eq 'new_client_id'
    end
  end

  describe '#client_secret' do
    it 'sets and returns default value' do
      GetnetApi.client_secret = nil
      expect(GetnetApi.client_secret).to eq GetnetApi::Configure::CLIENT_SECRET
      instance_client_secret = GetnetApi.instance_variable_get(:@client_secret)
      expect(instance_client_secret).to eq GetnetApi::Configure::CLIENT_SECRET
    end
  end

  describe '#client_secret=' do
    it 'correctly sets value' do
      GetnetApi.client_secret = 'new_client_secret'
      expect(GetnetApi.client_secret).to eq 'new_client_secret'
      instance_client_secret = GetnetApi.instance_variable_get(:@client_secret)
      expect(instance_client_secret).to eq 'new_client_secret'
    end
  end

  describe '#expires_in' do
    it 'sets and returns default value' do
      GetnetApi.expires_in = nil
      expected_date = DateTime.now - 1.day
      expect(GetnetApi.expires_in.to_date).to eq expected_date.to_date
      instance_expires_in = GetnetApi.instance_variable_get(:@expires_in)
      expect(instance_expires_in.to_date).to eq expected_date.to_date
    end
  end

  describe '#expires_in=' do
    it 'correctly sets value' do
      expected_date = DateTime.now + 1.day
      GetnetApi.expires_in = expected_date
      expect(GetnetApi.expires_in).to eq expected_date
      instance_expires_in = GetnetApi.instance_variable_get(:@expires_in)
      expect(instance_expires_in).to eq expected_date
    end
  end

  describe '#endpoint' do
    it 'sets and returns endpoint based on ambiente' do
      GetnetApi.instance_variable_set :@endpoint, nil
      ambiente = GetnetApi.ambiente
      expected_endpoint = GetnetApi::Configure::URL[ambiente]
      expect(GetnetApi.endpoint).to eq expected_endpoint
      instance_endpoint = GetnetApi.instance_variable_get(:@endpoint)
      expect(instance_endpoint).to eq expected_endpoint
    end
  end

  describe '#access_token=' do
    it 'correctly sets value' do
      GetnetApi.access_token = 'new_access_token'
      expect(GetnetApi.access_token).to eq 'new_access_token'
      instance_access_token = GetnetApi.instance_variable_get(:@access_token)
      expect(instance_access_token).to eq 'new_access_token'
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

  describe 'base_uri' do
    it 'returnes uri based on endpoint and api version' do
      expected_endpoint = "#{GetnetApi.endpoint}/#{GetnetApi.api_version}"
      expect(GetnetApi.base_uri).to eq expected_endpoint
    end
  end
end
