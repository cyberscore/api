require_relative 'game'

module Cyberscore::Model

  class LevelGroup < Sequel::Model
    many_to_one  :game
  end

end
