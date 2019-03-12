require 'fcm'

class FCMService
  attr_reader :fcm

  def initialize
    @api_key = Rails.application.secrets.FCM_API_KEY
    @fcm = FCM.new @api_key
  end

  def send(registration_ids = [], payload)
    @fcm.send(registration_ids, payload)
  end
end
