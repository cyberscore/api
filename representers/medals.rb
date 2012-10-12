module MedalsRepresenter
  include Roar::Representer::JSON::HAL

  property :platinum
  property :gold
  property :silver
  property :bronze
end