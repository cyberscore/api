require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::Submission

  module Historic
    include Roar::Representer::JSON::HAL

    property :update_type, as: :type
    property :update_date, as: :date
    property :submission
    property :chart_pos,   as: :position
  end

  module Item
    include Roar::Representer::JSON::HAL

    property :username
    property :platinum
    property :chart_pos, :as => :position
    property :game_name, :as => :game
    property :group
    property :chart
    property :submission
    property :csp
    property :last_update, :as => :date
    property :proof

    collection :history,
      class: OpenStruct,
      extend: Historic,
      embedded: true

    link :self       do "/submissions/#{level_id}" end
    link :index      do "/submissions"             end
    link :"cs:user"  do "/users/#{username}"       end
    link :"cs:game"  do "/games/#{game_id}"        end
    link :"cs:group" do "/games/#{game_id}/groups/#{level.group_id}" end
  end

  module Collection
    include Roar::Representer::JSON::HAL

    property :total

    collection :submissions,
      :class => OpenStruct,
      :extend => Item,
      :embedded => true

    link :rel => :self do "/submissions" end
    link :rel => :up   do "/" end
  end

end