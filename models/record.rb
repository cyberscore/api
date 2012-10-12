module Cyberscore::Model

  class Record < Sequel::Model
    one_to_many :user
    many_to_one :game
    many_to_one :level
  end

end