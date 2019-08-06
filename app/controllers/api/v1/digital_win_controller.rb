class Api::V1::DigitalWinController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: :game_token

  def game_token
    response = DigitalWinClient.get_game_token(game_token_params)
    if response['GameResponse']['RespMessage'] == 'Success'
      render json: response, status: :ok
    else
      render json: response, status: :bad_request
    end
  end

  private

  def game_token_params
    params.permit(:game_id, :username)
  end
end
