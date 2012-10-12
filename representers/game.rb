require 'roar/representer/json'
require 'roar/representer/json/hal'

module GameItem
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

module GameCollection
  include Roar::Representer::JSON::HAL
  
  property :total
  
  collection :games,
    :class    => OpenStruct,
    :extend   => GameItem,
    :embedded => true
  
  link :self do "/feeds/games" end
  link :up   do "/api"         end
end