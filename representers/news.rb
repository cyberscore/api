require 'roar/representer/json'
require 'roar/representer/json/hal'

module Cyberscore::Representer::News

  module Item
    include Roar::Representer::JSON::HAL

    property :news_id,   :as => :id
    property :headline
    property :news_date, :as => :date
    property :news_text, :as => :content

    link :self  do "/news/#{news_id}" end
    link :index do "/news"            end
    link :rel => :alternate,
      :type => 'application/html' do "http://cyberscore.me.uk/news/#{news_id}" end
    link :prev do "/news?id=#{news_id-1}" end
    link :next do "/news?id=#{news_id+1}" end
  end

  module Collection
    include Roar::Representer::JSON::HAL

    property :date

    collection :news,
      :class    => OpenStruct,
      :extend   => Item,
      :embedded => true

    link :self  do "/news" end
    link :up    do "/"     end
    link :first do "/news/#{first}" end
    link :last  do "/news/#{last}"  end
  end

end
