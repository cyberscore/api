module Cyberscore
  class API < Sinatra::Base

    get '/news' do
      redirect to("news/"+params["id"]) if params['id']

      params['news'] and limit = params['news'].to_i or limit = 10
      offset = params['page'].to_i * limit

      news = Model::News.order(:news_id.desc).limit(limit, offset)

      collection       = OpenStruct.new.extend(Representer::News::Collection)
      collection.date  = Date.today.to_s
      collection.first = news.reverse.first.news_id
      collection.last  = news.reverse.last.news_id
      collection.news  = news

      collection.to_json
    end

    get '/news/:id' do
      Model::News.find(:news_id => params[:id])   \
                 .extend(Representer::News::Item) \
                 .to_json
    end

  end
end
