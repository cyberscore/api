require_relative 'score'
require_relative 'submission'
require_relative 'game'
require_relative 'medals'

module UserItem
  include Roar::Representer::JSON::HAL

  property :user_id, :from => :id
  property :forename
  property :surname
  property :username
  property :date_lastseen, :from => :last_seen
  property :website

  property :medals

  collection :records,
             :class    => OpenStruct,
             :extend   => SubmissionRepresenter,
             :embedded => true

  link :rel => :self        do "/api/users/#{username}"                              end
  link :rel => :index       do "/api/users"                                          end
  link :rel => :records     do "/api/users/#{username}/records"                      end
  link :rel => :profile     do "http://cyberscore.me.uk/user/#{user_id}/stats"       end
  link :rel => :dashboard   do "http://cyberscore.me.uk/dashboard.php?id=#{user_id}" end
  link :rel => :rankbuttons do "/api/users/#{username}/rankbuttons"                  end
  link :rel => :search,
       :templated => true do "/api/users{?search}" end
end

module UserCollection
  include Roar::Representer::JSON::HAL

  attr_accessor :newest

  def initialize
    @newest = User.order(:user_id).last(5)
  end

  property :users_count, :from => :users

  # collection :users,
  #            :class => OpenStruct,
  #            :extend => UserItem,
  #            :embedded => true

  link :self  do "/api/users"          end
  link :first do "/api/users/#{first}" end
  link :last  do "/api/users/#{last}"  end
  link :up    do "/api"                end
  link :rel => :search,
       :templated => true do "/api/users{?username,id}" end
end
