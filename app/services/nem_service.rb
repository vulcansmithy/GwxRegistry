require 'nem'

class NemService
  def generate_account
    @node = Nem::Node.new(url: 'http://127.0.0.1:7890')
    @endpoint = Nem::Endpoint::Account.new(@node)
    @account = @endpoint.generate
  end
end
