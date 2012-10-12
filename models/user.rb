module Cyberscore::Model

  class User < Sequel::Model
    one_to_many :records
  end

end