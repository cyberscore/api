require_relative 'record_history'

module Cyberscore::Model

  class Record < Sequel::Model
    many_to_one :user
    many_to_one :game
    many_to_one :level
    one_to_many :record_history, class: Cyberscore::Model::RecordHistory

    def username
      user.username
    end

    def game_name
      game.name
    end

    def group
      level.group.group_name
    end

    def chart
      level.level_name
    end

    def proof
      return if self.linked_proof.nil?
      return if self.linked_proof.empty?

      { type: self.proof_type,
        deadline: self.proof_deadline,
        link: self.linked_proof
      }
    end

    def history
      record_history
    end

  end

end