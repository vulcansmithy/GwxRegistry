require 'aws-sdk-secretsmanager'
require 'base64'

class SecretsManager
  class << self
    def get_secret
      secret_name = 'registry_api_staging'
      region_name = 'ap-southeast-1'
      client = Aws::SecretsManager::Client.new(
        region: region_name,
        access_key_id: 'AKIA2X6IHDRGHMLRI5WU',
        secret_access_key: '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'
      )

      begin
        get_secret_value_response = client.get_secret_value(secret_id: secret_name)
      rescue Aws::SecretsManager::Errors::DecryptionFailure => e
        raise
      rescue Aws::SecretsManager::Errors::InternalServiceError => e
        raise
      rescue Aws::SecretsManager::Errors::InvalidParameterException => e
        raise
      rescue Aws::SecretsManager::Errors::InvalidRequestException => e
        raise
      rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
        raise
      else
        if get_secret_value_response.secret_string
          secret = get_secret_value_response.secret_string
        else
          decoded_binary_secret = Base64.decode64(get_secret_value_response.secret_binary)
        end
        JSON.parse(secret)
      end
    end
  end
end
