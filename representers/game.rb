require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::Game

  module Item
    include Roar::Representer::JSON::HAL

    property :game_id, :from => :id
    property :game_name, :from => :name
    property :game_tag, :from => :tag
    property :description
    property :developer
    property :total_charts, :from => :charts
    property :total_subs, :from => :submissions

    link :self  do "http://cyberscore.me.uk/game/#{game_id}" end
    link :index do "http://cyberscore.me.uk/games"           end
    link :rel => :search,
         :templated => true do "http://cyberscore.me.uk/games{?platform,name}" end
  end

  module Collection
    include Roar::Representer::JSON::HAL

    property :total

    collection :games,
      :class    => OpenStruct,
      :extend   => Item,
      :embedded => true

    link :self do "/feeds/games" end
    link :up   do "/"         end
  end

end