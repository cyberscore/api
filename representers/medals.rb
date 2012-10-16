module Cyberscore::Representer

  module Medals
    include Roar::Representer::JSON::HAL

    property :platinum
    property :gold
    property :silver
    property :bronze
  end

end