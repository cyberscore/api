module FeedRepresenter
  include Roar::Representer::JSON::HAL

  link :self        do "feeds" end
  link :submissions do "feeds/submissions" end
  link :news        do "feeds/news"        end
  link :games       do "feeds/games"       end
end