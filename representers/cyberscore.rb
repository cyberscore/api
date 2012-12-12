module Cyberscore::Representer

  module Root
    include Roar::Representer::JSON::HAL

    property :user_count
    property :motd

    link :self        do "http://cs-api.heroku.com/" end
    link :users       do "/users"       end
    link :news        do "/news"        end
    link :submissions do "/submissions" end
    link :games       do "/games"       end
  end

end