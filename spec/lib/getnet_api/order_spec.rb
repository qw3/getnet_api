# frozen_string_literal: true

describe GetnetApi::Order do
  let(:order) do
    GetnetApi::Order.new(
      order_id: '123',
      sales_tax: 0,
      product_type: 'service'
    )
  end

  it 'is valid with valid attributes' do
    expect(order).to be_valid
  end

  it 'is not valid with order id length > 36' do
    order.order_id = '1' * 37
    expect(order).not_to be_valid
    expect(order.errors.messages[:order_id]).to be_present
  end

  context '#to_request' do
    it 'returns order object as a hash' do
      order_hash = order.to_request
      order_hash.keys.each do |key|
        expect(order_hash[key]).to eq order.send(key)
      end
    end
  end
end
