# -*- encoding: UTF-8 -*-

require 'sinatra/base'
require 'sinatra/sequel'
require 'sinatra/jsonp'

require 'digest'
require 'yaml'
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
      resp = OpenStruct.new.extend(CyberscoreRepresenter)
      resp.motd = "Hello there! API still in progress :)"

      resp.to_json
    end

    get '/users' do
      if params['username']
        username = params.delete 'username'
        url = "/users/#{username}"

        redirect to("/users/#{username}")
      end

      # OpenStruct.new.extend(UserCollection).to_json
      users = Cyberscore::Model::User.order(:user_id.desc).first(5)

      collection = OpenStruct.new.extend(UserCollection)
      collection.users_count = Cyberscore::Model::User.count
      collection.first = users.reverse.first.username
      collection.last  = users.reverse.last.username
      collection.users = users

      return collection.to_json

      collection.to_json
    end
    get '/users/:name' do
      if params['name'].match(/\A\d+\z/)
        user = Cyberscore::Model::User.find(:user_id => params['name'])
      else
        user = Cyberscore::Model::User.find(:username => params['name'])
      end

      return {error: 'no user found'}.to_json if user.nil?

      medals = OpenStruct.new
      medals.platinum = Cyberscore::Model::Record.where(:user_id => user.pk).where(:platinum => 1).count
      medals.gold, medals.silver, medals.bronze = Cyberscore::Model::Record.
        join(:games, :game_id => :game_id).
        where(:user_id => user.pk).
        where('chart_pos <= 3').
        where(:site_id => 1).
        group_and_count(:chart_pos).all.map do |it|
        it.values[:count]
      end

      collection = OpenStruct.new(user).extend(UserItem)
      collection.records = user.records.reverse.first(10).each do |rec|
        rec
      end

      collection.platinum = medals.platinum
      collection.gold = medals.gold
      # collection.games = Cyberscore::Model::Game.where(:user_id1 => user.pk)
      collection.medals = medals.dup.extend(MedalsRepresenter)

      collection.to_json
    end
    get '/users/:name/records' do
      user = Cyberscore::Model::User.find(:username => params['name'])
      limit = params['limit'].nil? ? 10 : params['limit'].to_i

      coll = OpenStruct.new.extend(SubmissionCollection)
      coll.total       = user.records.count
      coll.submissions = params.key?('all') ?
        user.records : user.records.first(limit)

      # coll.submissions.each do |sub|
      #   game = sub.game
      #
      #   sub.game  = game.name
      #   sub.group = game.group
      #
      # end

      coll.to_json
    end

    get '/news' do
      redirect to("news/"+params["id"]) if params['id']

      params['news'] and limit = params['news'].to_i or limit = 10
      offset = params['page'].to_i * limit

      news = Cyberscore::Model::News.order(:news_id.desc).limit(limit, offset)

      news.each do |it|
        it.news_text = h(it.news_text).force_encoding "UTF-8"
      end

      collection       = OpenStruct.new.extend(NewsCollection)
      collection.date  = Date.today.to_s
      collection.first = news.reverse.first.news_id
      collection.last  = news.reverse.last.news_id
      collection.news  = news

      # hsh = Digest::SHA1.new.digest(news.first.to_s)

      collection.to_json
    end
    get '/news/:id' do
      Cyberscore::Model::News.find(:news_id => params[:id]).extend(NewsItem).to_json
    end

    get '/submissions' do
      # subs = main_page('subs')
      #
      user = Cyberscore::Model::User.find(:username => 'locks')

      subs = user.records.first(10)

      collection             = OpenStruct.new.extend(SubmissionCollection)
      # collection.user        = user.name
      collection.total       = subs.size
      collection.submissions = subs

      collection.to_json
    end

    get '/games' do
      games = Cyberscore::Model::Game.order(:game_id.desc).first(5)

      collection = OpenStruct.new.extend(GameCollection)
      collection.total = Cyberscore::Model::Game.count
      collection.games = games

      collection.to_json
    end
    get '/games/:id' do
      Cyberscore::Model::Game.find(:game_id => params[:id]).extend(GameItem).to_json
    end

  end
end
