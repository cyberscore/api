require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::Notification

  module Item
    include Roar::Representer::JSON::HAL

    property :unread
    property :type
    property :timestamp
    property :game
    property :chart

    link :self  do "/users/#{user.username}/notifications/#{notification_id}" end
    link :index do "/users/#{user.username}/notifications"       end
  end

  module Collection
    include Roar::Representer::JSON::HAL

    property :username
    property :total
    property :unread

    collection :notifications,
      class:    OpenStruct,
      extend:   Item,
      embedded: true

    link :self  do "/users/#{username}/notifications/#{id}" end
  end

end