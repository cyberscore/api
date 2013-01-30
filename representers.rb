require 'roar'
require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer

  module Relations
    include Roar::Representer::JSON::HAL

    link rel:     :curie,
         name:       :cs,
         templated: true do "/rels/{rel}" end
  end

end

require_relative 'representers/cyberscore'
require_relative 'representers/feed'
require_relative 'representers/game'
require_relative 'representers/medals'
require_relative 'representers/news'
require_relative 'representers/record'
require_relative 'representers/score'
require_relative 'representers/submission'
require_relative 'representers/user'
require_relative 'representers/notification'