class GameApplication < Doorkeeper::Application
  has_one :game, foreign_key: :oauth_application_id, class_name: 'Game'
end
