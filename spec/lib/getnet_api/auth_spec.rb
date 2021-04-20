# -*- encoding : utf-8 -*-

describe GetnetApi::Auth do
  it 'is valid with attributes' do
    auth = GetnetApi::Auth.new('seller_id', 'client_id', 'client_secret')
    expect(auth).to be_valid
  end

  it 'is valid with missing attributes' do
    auth = GetnetApi::Auth.new(nil, nil, nil)
    expect(auth).not_to be_valid
    expect(auth.errors[:seller_id]).to be_present
    expect(auth.errors[:client_id]).to be_present
    expect(auth.errors[:client_secret]).to be_present
  end
end
