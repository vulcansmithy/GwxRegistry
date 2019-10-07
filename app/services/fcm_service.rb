require 'fcm'

class FCMService
  def initialize
    @api_key = ENV['FCM_API_KEY']
    @fcm = FCM.new @api_key
  end

  def notify(registration_ids = [], payload)
    @fcm.send(registration_ids, payload)
  end
end
