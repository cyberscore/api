# -*- encoding: UTF-8 -*-
require 'sinatra/base'
require 'sinatra/sequel'
require 'sinatra/jsonp'

require 'better_errors'

require 'json'

require 'ostruct'

module Cyberscore
  class API < Sinatra::Base
    helpers Sinatra::Jsonp

    configure do
      use BetterErrors::Middleware
      BetterErrors.application_root = File.expand_path("..", __FILE__)

      set :raise_errors, true
      set :show_exceptions, true

      Sequel::Model.db = Sequel.connect ENV['CS4_MYSQL']
      Sequel::Model.db.convert_invalid_date_time = nil
      Sequel::Model.plugin :force_encoding, 'UTF-8'

      require_relative 'models'
      require_relative 'representers'
      require_relative 'routes'

      mime_type :hal, 'application/hal+json'
    end

    before do
      cache_control :public, :max_age => 36000
      content_type :json# if request.accept.include? "json"
      # content_type :hal if request.accept.include? "application/hal+json"
    end


    get '/' do
      resp = OpenStruct.new.extend(Representer::Root)
      resp.motd = "Hello there! API still in progress :)"

      resp.to_json
    end

    get '/explorer' do
      content_type :html

      send_file 'public/hal_browser.html'
    end

    get '/submissions' do
      user = Model::User.find(:username => 'locks')

      subs = user.records.first(10)

      collection             = OpenStruct.new.extend(Representer::Submission::Collection)
      collection.total       = subs.size
      collection.submissions = subs

      collection.to_json
    end

    get '/games' do
      games = Model::Game.order(:game_id.desc).first(5)

      collection = OpenStruct.new.extend(Representer::Game::Collection)
      collection.total = Model::Game.count
      collection.games = games

      collection.to_json
    end
    get '/games/:id' do
      Model::Game.find(:game_id => params[:id]) \
        .extend(Representer::Game::Item).to_json
    end

  end
end
