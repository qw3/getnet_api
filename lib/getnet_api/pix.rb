module GetnetApi
  class Pix
    # string 200 characters
    # Código de identificação da compra utilizado pelo e-commerce. Caso seja informado ele será repassado na Notificação de Pagamento PIX.
    attr_accessor :order_id

    # string 36 characters
    # Identificador do comprador utilizado pelo e-commerce. Caso seja informado ele será repassado na Notificação de Pagamento PIX.
    attr_accessor :customer_id

    # Validações do Rails 3
    include ActiveModel::Validations

    validates :order_id, length: {maximum: 200}
    validates :customer_id, length: {maximum: 36}

    # Nova instancia da classe Pix
    # @param [Hash] campos
    def initialize(campos = {})
      campos.each do |campo, valor|
        if GetnetApi::Pix.public_instance_methods.include? "#{campo}=".to_sym
          send "#{campo}=", valor
        end
      end
    end

    # Montar o Hash de dados do pagamento no padrão utilizado pela Getnet
    def to_request
      {
        order_id: order_id,
        customer_id: customer_id
      }
    end
  end
end
