module Cyberscore::Model

  class Level < Sequel::Model
    many_to_one :group, :class => 'Cyberscore::Model::LevelGroup'
  end

end
