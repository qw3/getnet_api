# -*- encoding : utf-8 -*-
require 'rubygems'
require 'active_model'
require 'active_support/time'
require 'json'

require "getnet_api/version"
require "getnet_api/configure"
require "getnet_api/base"
require "getnet_api/card"
require "getnet_api/card_token"
require "getnet_api/card_verification"
require "getnet_api/customer"
require "getnet_api/address"
require "getnet_api/order"
require "getnet_api/boleto"
require "getnet_api/credit"
require "getnet_api/payment"
require "getnet_api/payment_cancel"
require "getnet_api/auth"


# -*- encoding : utf-8 -*-
module GetnetApi
  extend GetnetApi::Configure

end
