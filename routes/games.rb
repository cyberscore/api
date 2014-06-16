module Cyberscore
  class API < Sinatra::Base

    get '/games' do
      games = Model::Game.reverse_order(:game_id).first(5)

      collection = OpenStruct.new.extend(Representer::Game::Collection)
      collection.total = Model::Game.count
      collection.games = games

      collection.to_json
    end

    namespace '/games/:game' do
      before do
        game_id = params['game'].to_i

        @game = Model::Game.find[game_id]
      end

      get '' do
        @game.extend(Representer::Game::Item).to_json
      end

      get '/charts' do
      end

      get '/charts/:chart' do
      end

    end

  end
end