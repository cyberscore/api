require 'roar'
require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer

  module Relations
    include Roar::Representer::JSON::HAL

    link rel:       :curie,
         name:      :cs,
         templated: true do "/rels/{rel}" end
  end

end

module Cyberscore::Representer
  autoload :Error,        './representers/error'
  autoload :Root,         './representers/cyberscore'
  autoload :Feed,         './representers/feed'
  autoload :Game,         './representers/game'
  autoload :Medals,       './representers/medals'
  autoload :News,         './representers/news'
  autoload :Record,       './representers/record'
  autoload :Score,        './representers/score'
  autoload :Submission,   './representers/submission'
  autoload :User,         './representers/user'
  autoload :Notification, './representers/notification'
end