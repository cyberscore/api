require_relative 'score'
require_relative 'submission'
require_relative 'game'
require_relative 'medals'

module Cyberscore::Representer::User

  module Item
    extend  Cyberscore::Representer::Relations
    include Roar::Representer::JSON::HAL

    property :user_id, :from => :id
    property :forename
    property :surname
    property :username
    property :date_lastseen, :from => :last_seen
    property :website

    property :medals,
             :class  => OpenStruct,
             :extend => Cyberscore::Representer::Medals

    collection :newest_records,
               :class    => OpenStruct,
               :extend   => Cyberscore::Representer::Submission::Item,
               :embedded => true

    link :self         do "/users/#{username}"         end
    link :index        do "/users"                     end
    link :"cs:records" do "/users/#{username}/records" end
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

    property :users_count, :from => :users

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