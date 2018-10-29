# -*- encoding : utf-8 -*-
module GetnetApi
  module Configure

    # Endereço do wsdl funções:
    # [Criar Transação pagamentoTransacaoCompleta, Capturar operacaoTransacao, Cancelar operacaoTransacao, Consultar consultaTransacaoEspecifica]
    # [Estornar estornaTransacao] - Estorno
    URL = {
      :homologacao          => "https://api-homologacao.getnet.com.br",
      :sandbox              => "https://api-sandbox.getnet.com.br",
      :producao             => "https://api.getnet.com.br",
    }

    # Parâmetros iniciais
    AMBIENTE          = :sandbox # :sandbox ou :homologacao ou :producao
    # Parâmetros iniciais
    API_VERSION       = 'v1'
    # Parâmetros iniciais
    SELLER_ID         = '5c89ec4a-db89-45a6-8c96-5b0b72907ef5'
    # Parâmetros iniciais
    CLIENT_ID         = 'f43f4b25-fd05-420a-bffc-0dc85428ebd0'
    # Parâmetros iniciais
    CLIENT_SECRET     = '31e285f9-5d97-4370-9553-326310ca8b97'

    # Define o ambiente de trabalho
    # Simbolo - Valores pré-definidos [:sandbox, :homologacao, :producao]
    attr_writer :ambiente

    # Enviado pela Getnet
    attr_writer :api_version

    # Enviado pela Getnet
    attr_writer :seller_id

    # Enviado pela Getnet
    attr_writer :client_id

    # Enviado pela Getnet
    attr_writer :client_secret

    # Token de acesso utilizado nas demais requisições
    attr_writer :access_token
    attr_writer :expires_in

    # Comando que recebe as configuracoes
    def configure
      yield self if block_given?
    end

    # Definir ambiente
    def ambiente
      @ambiente ||= AMBIENTE
    end

    # Definir Versão da API da Getnet
    def api_version
      @api_version ||= API_VERSION
    end

    # Definir seller_id
    def seller_id
      @seller_id ||= SELLER_ID
    end

    # Definir client_id
    def client_id
      @client_id ||= CLIENT_ID
    end

    # Definir client_secret
    def client_secret
      @client_secret ||= CLIENT_SECRET
    end

    # Definir endpoint
    def endpoint
      @endpoint ||= set_endpoint
    end

    # Definir access_token
    def access_token
      @access_token ||= ""
    end
    # Definir Versão da API da Getnet
    def expires_in
      @expires_in ||= DateTime.now - 1.day
    end

    # Retornar a url conforme o ambiente
    def set_endpoint
      if ambiente == :producao
        return GetnetApi::Configure::URL[:producao]
      elsif ambiente == :homologacao
        return GetnetApi::Configure::URL[:homologacao]
      else
        return GetnetApi::Configure::URL[:sandbox]
      end
    end

    def base_uri
      return "#{self.endpoint}/#{self.api_version}/"
    end

  end
end
