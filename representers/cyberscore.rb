module CyberscoreRepresenter
  include Roar::Representer::JSON::HAL

  property :user_count
  property :motd

  link :self        do "http://cs-api.heroku.com/api" end
  link :users       do "/api/users"       end
  link :news        do "/api/news"        end
  link :submissions do "/api/submissions" end
  link :games       do "/api/games"       end
end