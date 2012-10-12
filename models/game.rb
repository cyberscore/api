module Cyberscore::Model

  class Game < Sequel::Model
    many_to_one :genre

    alias_method :name, :game_name
  end

end