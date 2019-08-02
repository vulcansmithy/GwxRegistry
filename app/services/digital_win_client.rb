class DigitalWinClient
  include HTTParty
  format :xml
  base_uri Rails.application.secrets.digital_win_base_url

  API_KEY = Rails.application.secrets.api_key
  API_ID = Rails.application.secrets.api_id
  AGENT_ID = Rails.application.secrets.agent_id

  class << self
    def get_game_token(args)
      body = {
        RequestType: 'GetGameTokenNR',
        WebCallID: API_ID,
        WebCallKey: API_KEY,
        AgentID: AGENT_ID,
        PlayerID: args[:username],
        GameID: args[:game_id],
        ReqDateTime: DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
      }.to_xml(root: 'GameRequest')

      post('/CasinoGameServ3/servlet/PacGameServices', body: body)
    end
  end
end
