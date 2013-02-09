module Cyberscore::Representer

  module Error
    include Roar::Representer::JSON::HAL

    property :status
    property :description

    link :self do "#{request_path}" end
  end

end