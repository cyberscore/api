module Cyberscore::Model

  class Level < Sequel::Model
    many_to_one :group, :class => 'Cyberscore::Model::LevelGroup'
    many_to_one :game

    def name
      level_name
    end
  end

end
