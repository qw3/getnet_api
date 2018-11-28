# Gem Getnet API - Meios de Pagamento

## Versão Beta

Gem para utilização dos meios de pagamento [Getnet](https://site.getnet.com.br/) - Uma empresa Santander para integrar sua plataforma de forma segura e eficaz com as principais formas de pagamento disponíveis no mercado.

Acesso a documentação de desenvolvimento da [Getnet](https://developers.getnet.com.br/)

## Instalando

### Gemfile

Adicione esta linha ao Gemfile do seu aplicativo:

```ruby
  gem 'getnet_api'
```

 - Execute o comando `bundle install`.

### Instalação direta

```ruby
  gem install getnet_api
```

## Configuração

Para fazer a autenticação, você precisará configurar as credenciais da Getnet. Crie o arquivo `config/initializers/getnet_api.rb` com o conteúdo abaixo.

```ruby
GetnetApi.configure do |config|

  #
  # Opções de ambiente
  # [:sandbox, :homologacao, :producao]
  config.ambiente = :producao

  #
  # Código que identifica o seller_id dentro da Getnet
  # Enviado pela Getnet
  config.seller_id = '5c89ec4a-db89-45a6-8c96-5b0b72907ef5'

  #
  # Código que identifica o client_id dentro da Getnet
  # Enviado pela Getnet
  config.client_id = 'f43f4b25-fd05-420a-bffc-0dc85428ebd0'

  #
  # Código que identifica o client_secret dentro da Getnet
  # Enviado pela Getnet
  config.client_secret = '31e285f9-5d97-4370-9553-326310ca8b97'

end
```

## Pagamentos

Nesse endpoint serão recebidos dados para os pagamentos.


### Montar [Endereço](http://www.rubydoc.info/github/qw3/superpay_api/GetnetApi/Address)

```ruby
obj_endereco = GetnetApi::Address.new ({
  street:       "Rua Dom Pedro II",
  number:       "1330",
  district:     "Vila Monteiro (Gleba I)",
  complement:   "Sala A",
  city:         "São Carlos",
  state:        "SP",
  postal_code:  "13560320",
})
```

### Montar [Cliente](http://www.rubydoc.info/github/qw3/superpay_api/GetnetApi/Customer)

```ruby
obj_cliente = GetnetApi::Customer.new ({
  customer_id:      1,
  first_name:       "Leandro",
  last_name:        "Falcão",
  name:             "Leandro Falcão",
  document_type:    :pessoa_fisica,
  documento:        "999.999.999-9",
  email:            "contato@qw3.com.br",
  phone_number:     "1634166404",
  celphone_number:  "16955555555",
  endereco:         obj_endereco, # Objeto da classe GetnetApi::Address
})
```

### Montar [Pedido](http://www.rubydoc.info/github/qw3/superpay_api/GetnetApi/Order)

```ruby
obj_pedido = GetnetApi::Order.new ({
  order_id:      "123456",
  sales_tax:     12,
  product_type:  "phisical_goods"
})
```

---

### Montar [Pagamento](http://www.rubydoc.info/github/qw3/superpay_api/GetnetApi/Payment)

```ruby
obj_pagamento = GetnetApi::Payment.new ({
  amount:           100,        # Quantidade em centavos
  order:            obj_pedido, # Objeto da classe GetnetApi::Order
  customer:         obj_cliente, # Objeto da classe GetnetApi::Customer
  billing_address:  obj_endereco, # Objeto da classe GetnetApi::Address
})
```
## Criando um pagamento na GetNet do tipo Credit

### Montar [Cartão](http://www.rubydoc.info/github/qw3/superpay_api/GetnetApi/Credit)

```ruby
obj_credit = GetnetApi::Credit.new ({
  delayed: false,
  authenticated: false,
  pre_authorization: false,
  save_card_data: false,
  transaction_type: 'FULL',
  number_installments: 1,
  soft_descriptor: '',
  dynamic_mcc: ''
})
```

```ruby
# No Caso de pagamento com Cartão de Credito
# GetnetApi::Payment.create(GetnetApi::Payment, GetnetApi::Credit, tipo)
novo_pagamento = GetnetApi::Payment.create obj_pagamento, obj_credito, :credit
```

---

## Criando um pagamento na GetNet do tipo Boleto

### Montar [Boleto](http://www.rubydoc.info/github/qw3/superpay_api/GetnetApi/Boleto)

```ruby
obj_boleto = GetnetApi::Boleto.new ({
  our_number: "000001946598",
  document_number: "170500000019763",
  expiration_date: "16/11/2017",
  instructions: "Não receber após o vencimento",
  provider: "santander"
})
```

```ruby
# No Caso de pagamento de Boleto
# GetnetApi::Payment.create(GetnetApi::Payment, GetnetApi::Boleto, tipo)
novo_pagamento = GetnetApi::Payment.create obj_pagamento, obj_boleto, :boleto
```

---


## Autor

- [QW3 Software & Marketing](http://qw3.com.br)
- [Leandro dos Santos Falcão](https://www.linkedin.com/in/lsfalcao)
- [Victor Barreiros](www.linkedin.com/in/victor-barreiros)

## Copyright

[QW3 Software & Marketing](http://qw3.com.br)

![QW3 Logo](http://qw3.com.br/qw3_logo.png)

MIT License

Copyright (c) 2018 QW3 - Software, Marketing e Consultoria

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.