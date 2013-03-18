require_relative 'record'
require_relative 'notification'

module Cyberscore::Model

  class User < Sequel::Model
    one_to_many :records
    one_to_many :notification

    def_column_alias :id, :user_id

    def newest_records(this_much=10)
      @newest_records ||= records.reverse.first this_much
    end

    def medals
      Struct.new(:platinum, :gold, :silver, :bronze).new.tap do |medals|
        medals.platinum = Record.where([user_id: self.pk], [platinum: 1]).count

        top_3 = Record.join(:games, :game_id => :game_id)              \
          .where([user_id: self.pk], ['chart_pos <= 3'], [site_id: 1]) \
          .group_and_count(:chart_pos).all.map do |it|
            it.values[:count]
          end

        medals.gold, medals.silver, medals.bronze = top_3.fill 0, top_3.length...3
      end
    end

    def games
      records.first.game
    end

    def proofs
      Record.where([user_id: self.pk],
                   [rec_status: 3],
                   ['linked_proof != ""'])
            .where('rec_status', 3)
    end
  end

end
