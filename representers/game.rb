require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::Game

  module Item
    include Roar::Representer::JSON::HAL

    property :game_id, :as => :id
    property :game_name, :as => :name
    property :game_tag, :as => :tag
    property :description
    property :developer
    property :total_charts, :as => :charts
    property :total_subs, :as => :submissions

    link :self  do "http://cyberscore.me.uk/game/#{game_id}" end
    link :index do "http://cyberscore.me.uk/games"           end
    link :rel => :search,
         :templated => true do "http://cyberscore.me.uk/games{?platform,name}" end
    link :proof do "#{proof_link}" end
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