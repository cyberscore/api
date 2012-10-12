require 'roar/representer/json'
require 'roar/representer/json/hal'

module NewsItem
  include Roar::Representer::JSON::HAL

  property :news_id,   :from => :id
  property :headline
  property :news_date, :from => :date
  property :news_text, :from => :content

  link :self  do "/api/news/#{news_id}" end
  link :index do "/api/news"            end
  link :rel => :alternate,
    :type => 'application/html' do "http://cyberscore.me.uk/news/#{news_id}" end
  link :prev do "/api/news?id=#{news_id-1}" end
  link :next do "/api/news?id=#{news_id+1}" end
end

module NewsCollection
  include Roar::Representer::JSON::HAL

  property :date

  collection :news,
    :class    => OpenStruct,
    :extend   => NewsItem,
    :embedded => true

  link :self do "/api/news" end
  link :up   do "/api"      end
  link :first do "/api/news/#{first}" end
  link :last  do "/api/news/#{last}"  end
end
