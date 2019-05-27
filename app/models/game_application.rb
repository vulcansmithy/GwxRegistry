class GameApplication < Doorkeeper::Application
  has_one :game, foreign_key: :game_application_id, class_name: 'Game'
end
