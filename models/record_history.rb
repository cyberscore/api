module Cyberscore::Model

  class RecordHistory < Sequel::Model(:record_history)
    many_to_one :record

  end

end