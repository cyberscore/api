module Cyberscore::Model

  class Record < Sequel::Model
    one_to_many :user
    many_to_one :game
    many_to_one :level

    def game_name
      game.name
    end

    def group
      level.group.group_name
    end

    def chart
      level.level_name
    end
  end

end