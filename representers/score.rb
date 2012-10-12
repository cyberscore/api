module ScoreRepresenter
  include Roar::Representer::JSON::HAL

  property :cs_points
  property :chart_pos
  property :submission
  property :last_update
  property :comment
end
