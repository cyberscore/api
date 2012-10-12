require 'roar/representer/json'
require 'roar/representer/json/hal'

module SubmissionRepresenter
  include Roar::Representer::JSON::HAL

  property :platinum
  property :chart_pos, :from => :position
  property :game
  # property :group
  # property :chart
  property :submission
  property :cs_points, :from => :csp
  property :last_update

  # property :user

  link :rel => :self  do "/api/submissions/#{level_id}" end
  link :rel => :game  do "/api/games/#{game_id}"        end
  link :rel => :index do "/api/submissions"             end
end

module SubmissionCollection
  include Roar::Representer::JSON::HAL

  property :total

  collection :submissions,
    :class => OpenStruct,
    :extend => SubmissionRepresenter,
    :embedded => true

  link :rel => :self do "/api/submissions" end
  link :rel => :up   do "/api" end
end
