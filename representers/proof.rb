require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::Proof

  module Item
    include Roar::Representer::JSON::HAL

    property :type
    property :source

  end

  module Collection
    include Roar::Representer::JSON::HAL
  end

end