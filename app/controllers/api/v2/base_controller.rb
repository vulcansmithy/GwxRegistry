class Api::V2::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :authenticate_request

  attr_reader :current_user

  include ExceptionHandler

  def index
    render json: { message: OK }, status: :ok
  end

  def success_response(response_payload, status_code = :ok)
    render json: response_payload, status: status_code
  end

  def error_response(message, errors, status_code)
    render json: { message: message, errors: errors }, status: status_code
  end

  private

  def authenticate_request
    if doorkeeper_token&.resource_owner_id
      @current_user = User.find doorkeeper_token.resource_owner_id
    else
      error_response '', 'Unauthorize access', :unauthorized
    end
  end

  def check_player_publisher_account(user, account)
    return unless user.send("#{account}")
    error_response("Unable to create account",
                   "#{account.capitalize} account already exist",
                   :unprocessable_entity)
  end

  def check_current_user
    raise ExceptionHandler::AuthenticationError,
      'Unauthorized: Access is denied' unless
      @current_user == User.find(params[:user_id] || params[:id])
  end

  def transform_params
    params.transform_keys!(&:underscore)
  end
  
  def distribute_shards(wallet_address, shards)

    # define the url for the Cashier API create new Shard endpoint
    cashier_api_shard_endpoint = "#{ENV["CASHIER_SHARDING_URL"]}/shards"
    
    # prepare payload for the Cashier API
    body = {
      wallet_address: wallet_address,
      custodian_key: shards[1]
    }.to_json
    
    # call Cashier API and create a new Shard
    response = HTTParty.post(cashier_api_shard_endpoint,
      body: body,
      headers: {
        "Content-Type": "application/json"
      }
    )
    
    # make sure the response code is :created before continuing
    raise "Can't reach Cashier API." unless response.code == 201



    # define the url for the CustodianVault API create new Shard endpoint
    custodian_vault_api_shard_endpoint = "#{ENV["CUSTODIAN_VAULT_URL"]}/shards"
    
    # prepare payload for the CustodianVault API
    body = {
      wallet_address: wallet_address,
      custodian_key: shards[2]
    }.to_json
    
    # call CustodianVault API and create a new Shard
    response = HTTParty.post(custodian_vault_api_shard_endpoint,
      body: body,
      headers: {
        "Content-Type": "application/json"
      }
    )
    
    # make sure the response code is :created before continuing
    raise "Can't reach CustodianVault API." unless response.code == 201
  end
  
end
