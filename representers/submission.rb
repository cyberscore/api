require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::Submission

  module Item
    include Roar::Representer::JSON::HAL

    property :platinum
    property :chart_pos, :from => :position
    property :game_name, :from => :game
    property :group
    property :chart
    property :submission
    property :csp
    property :last_update, :from => :date


    link :self       do "/submissions/#{level_id}" end
    link :index      do "/submissions"             end
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