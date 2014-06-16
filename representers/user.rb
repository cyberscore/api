require_relative 'score'
require_relative 'submission'
require_relative 'game'
require_relative 'medals'
require_relative 'notification'

module Cyberscore::Representer::User

  module Game
    include Roar::Representer::JSON::HAL

    property :game_name, as: :name
    property :submissions
    property :medals,
             :class  => OpenStruct,
             :extend => Cyberscore::Representer::Medals

    link :self do "/games/#{game_id}" end
  end

  module Item
    extend  Cyberscore::Representer::Relations
    include Roar::Representer::JSON::HAL

    property :user_id, :as => :id
    property :forename
    property :surname
    property :username
    property :date_lastseen, :as => :lastSeen
    property :website

    property :medals,
             :class  => OpenStruct,
             :extend => Cyberscore::Representer::Medals

    # collection :newest_records,
    #            :class    => OpenStruct,
    #            :extend   => Cyberscore::Representer::Submission::Item,
    #            :embedded => true

    link :self               do "/users/#{username}"               end
    link :index              do "/users"                           end
    link :"cs:records"       do "/users/#{username}/records"       end
    link :rel  => :profile, :type => 'text/html' do
      "http://cyberscore.me.uk/user/#{user_id}/stats"
    end
    link :rel  => :"cs:dashboard", :type => 'text/html' do
      "http://cyberscore.me.uk/dashboard.php?id=#{user_id}"
    end
  end

  module AuthorizedItem
    include Roar::Representer::JSON::HAL

    property :user_id, :as => :id
    property :forename
    property :surname
    property :username
    property :date_lastseen, :as => :lastSeen
    property :website

    property :medals,
             :class  => OpenStruct,
             :extend => Cyberscore::Representer::Medals


    collection :notification,
               :as       => :notifications,
               :class    => OpenStruct,
               :extend   => Cyberscore::Representer::Notification::Item,
               :embedded => true

    link :self               do "/users/#{username}"               end
    link :index              do "/users"                           end
    link :"cs:records"       do "/users/#{username}/records"       end
    link :"cs:notifications" do "/users/#{username}/notifications" end
    link :rel  => :profile, :type => 'text/html' do
      "http://cyberscore.me.uk/user/#{user_id}/stats"
    end
    link :rel  => :"cs:dashboard", :type => 'text/html' do
      "http://cyberscore.me.uk/dashboard.php?id=#{user_id}"
    end
    link :rel => :search, :templated => true do
      "/users{?search}"
    end

  end

  module Collection
    include Roar::Representer::JSON::HAL

    attr_accessor :newest

    def initialize
      @newest = Cyberscore::Model::User.order(:user_id).last(5)
    end

    property :users_count, :as => :users

    collection :users,
               :class => OpenStruct,
               :extend => Item,
               :embedded => true

    link :self  do "/users"                          end
    link :first do "/users/#{users.last.username}"   end
    link :last  do "/users/#{users.first.username}"  end
    link :rel => :search,
         :templated => true do "/users{?username,id}" end
  end

end