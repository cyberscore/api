require_relative 'user'
require_relative 'level'

module Cyberscore::Model

  class Notification < Sequel::Model
    many_to_one :user
    many_to_one :level, key: :chart_id

    def unread
      note_seen.eql? 'n'
    end

    def timestamp
      note_time
    end

    def game
      level.game.name
    end

    def chart
      level.name
    end
  end

end