# -*- encoding: UTF-8 -*-
require 'sinatra/base'
require 'sinatra/sequel'
require 'sinatra/jsonp'

require 'json'

require 'open-uri'
require 'ostruct'
require 'nokogiri'

module Cyberscore
  class API < Sinatra::Base
    helpers Sinatra::Jsonp

    configure do
      set :raise_errors, true
      set :show_exceptions, true

      Sequel::Model.db = Sequel.connect ENV['CS4_MYSQL']
      Sequel::Model.db.convert_invalid_date_time = nil
      Sequel::Model.plugin :force_encoding, 'UTF-8'

      require_relative 'models'
      require_relative 'representers'

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


    get '/users' do
      if params['username']
        username = params.delete 'username'
        url = "/users/#{username}"

        redirect to("/users/#{username}")
      end

      users = Model::User.order(:user_id.desc).first(5)

      collection = OpenStruct.new.extend(Representer::User::Collection)
      collection.users_count = Model::User.count
      collection.first       = users.reverse.first.username
      collection.last        = users.reverse.last.username
      collection.users       = users

      collection.to_json
    end
    get '/users/:name' do
      if params['name'].match(/\A\d+\z/)
        user = Model::User.find(:user_id => params['name'])
      else
        user = Model::User.find(:username => params['name'])
      end

      return {error: 'no user found'}.to_json if user.nil?

      collection = OpenStruct.new(user).extend(Representer::User::Item)
      collection.records = user.records.reverse.first(10)
      collection.medals  = user.medals

      collection.to_json
    end
    get '/users/:name/records' do
      user = Model::User.find(:username => params['name'])
      limit = params['limit'].nil? ? 10 : params['limit'].to_i

      coll = OpenStruct.new.extend(Representer::Subsbmission::Collection)
      coll.total       = user.records.count
      coll.submissions = params.key?('all') ?
        user.records : user.records.first(limit)

      coll.to_json
    end

    get '/news' do
      redirect to("news/"+params["id"]) if params['id']

      params['news'] and limit = params['news'].to_i or limit = 10
      offset = params['page'].to_i * limit

      news = Model::News.order(:news_id.desc).limit(limit, offset)

      news.each do |it|
        it.news_text = escape_html(it.news_text)
      end

      collection       = OpenStruct.new.extend(Representer::News::Collection)
      collection.date  = Date.today.to_s
      collection.first = news.reverse.first.news_id
      collection.last  = news.reverse.last.news_id
      collection.news  = news

      collection.to_json
    end
    get '/news/:id' do
      Model::News.find(:news_id => params[:id]).extend(Representer::News::Item).to_json
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
      Model::Game.find(:game_id => params[:id]).extend(Representer::Game::Item).to_json
    end

  end
end
