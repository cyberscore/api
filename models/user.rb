require_relative 'record'

module Cyberscore::Model

  class User < Sequel::Model
    one_to_many :records

    def medals
      medals = OpenStruct.new
      medals.platinum = Record.where(:user_id => self.pk).where(:platinum => 1).count

      top_3 = Record.
        join(:games, :game_id => :game_id).
        where(:user_id => self.pk).where('chart_pos <= 3').where(:site_id => 1).
        group_and_count(:chart_pos).all.map do |it|
          it.values[:count]
        end

      medals.gold, medals.silver, medals.bronze = top_3.fill 0, top_3.length...3

      medals
    end
  end

end
