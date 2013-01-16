# -*- encoding: UTF-8 -*-
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/sequel'
require 'sinatra/jsonp'

require 'better_errors'

require 'json'

require 'ostruct'

module Cyberscore
  class API < Sinatra::Base
    register Sinatra::Namespace
    helpers Sinatra::Jsonp

    helpers do
      def protected!
        binding.pry_remote

        return if authorized?

        response['WWW-Authenticate'] = %(Basic real="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && user_login_correct?
      end

      def user_login_correct?
        return false if @auth.credentials.all? {|it| it.empty? }

        user = Model::User.find(:username => @auth.username)
        user.pword == Digest::MD5.hexdigest(@auth.credentials.last)
      end
    end

    configure do
      use BetterErrors::Middleware
      BetterErrors.application_root = File.expand_path("..", __FILE__)
      BetterErrors.logger           = Logger.new $stdout

      set :raise_errors, true
      set :show_exceptions, true

      Sequel::Model.db = Sequel.connect ENV['CS4_MYSQL']
      Sequel::Model.db.convert_invalid_date_time = nil
      Sequel::Model.plugin :force_encoding, 'UTF-8'

      require_relative 'models'
      require_relative 'representers'
      require_relative 'routes'

      # mime_type :hal, 'application/hal+json'
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

  end
end
