class DigitalWinClient
  include HTTParty
  format :xml
  base_uri ENV['DIGITAL_WIN_BASE_URL']

  class << self
    def get_game_token(args)
      body = {
        RequestType: 'GetGameTokenNR',
        WebCallID: ENV['DIGITAL_WIN_API_ID'],
        WebCallKey: ENV['DIGITAL_WIN_API_KEY'],
        AgentID: ENV['DIGITAL_WIN_AGENT_ID'],
        PlayerID: args[:username],
        GameID: args[:game_id],
        ReqDateTime: DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
      }.to_xml(root: 'GameRequest')

      post('/CasinoGameServ3/servlet/PacGameServices', body: body)
    end
  end
end
