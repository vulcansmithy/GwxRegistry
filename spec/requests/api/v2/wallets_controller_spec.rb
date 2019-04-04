require "rails_helper"

describe Api::V2::WalletsController do

  it "should implement the enpoint GET /:wallet_address" do
    # setup a test player with wallet account
    user = create(:user)
    wallet = user.create_wallet(wallet_address: 'TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW', pk: '4004d8f417a93c3197e5fb55ce5fdeec1bc161f3a4f207c7c3ada30edb5094a0')

    # login created user
    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    get "/wallets/#{user.wallet.wallet_address}"
    result = JSON.parse(response.body)

    expect(result['data']['attributes']['wallet_address']).to eq user.wallet.wallet_address
  end

  it "should implement the enpoint GET /:wallet_address/balance" do
    # setup a test player with wallet account
    user = create(:user)
    wallet = user.create_wallet(wallet_address: 'TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW', pk: '4004d8f417a93c3197e5fb55ce5fdeec1bc161f3a4f207c7c3ada30edb5094a0')
    xem_balance = 692.289674
    gwx_balance = 99084

    # login created user
    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    get "/wallets/#{user.wallet.wallet_address}/balance", headers: {Authorization: result['token']}
    result = JSON.parse(response.body)

    expect(result['balance']['xem']).to eq xem_balance
    expect(result['balance']['gwx']).to eq gwx_balance
  end
end
