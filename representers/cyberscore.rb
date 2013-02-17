module Cyberscore::Representer

  module Root
    include Roar::Representer::JSON::HAL

    property :user_count
    property :motd

    link :self             do "http://cs-api.heroku.com/" end
    link :"cs:users"       do "/users"       end
    link :"cs:news"        do "/news"        end
    link :"cs:submissions" do "/submissions" end
    link :"cs:games"       do "/games"       end
  end

end