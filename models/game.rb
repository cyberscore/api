module Cyberscore::Model

  class Game < Sequel::Model
    many_to_one :genre

    def_column_alias :name, :game_name

    # def name
    #   game_name
    # end

  end

end
