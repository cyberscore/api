module Cyberscore
  module Error
    class UserNotFound
      attr_accessor :username, :request_path

      def initialize(request_path, username)
        @request_path = request_path
        @username     = username
      end

      def status
        404
      end

      def description
        "User #{username} not found"
      end
    end
  end

  class API < Sinatra::Base

    get '/users' do
      users = Model::User.order(:user_id.desc).first(5)

      collection = OpenStruct.new.extend(Representer::User::Collection)
      collection.users_count = Model::User.count
      collection.users       = Model::User.order(:user_id.desc).first(5)

      collection.to_json
    end

    namespace '/users/:name' do
      before do
        @name = params['name']

        @user = Model::User.find(:username => @name)

        # if @user.nil?
        #   halt 404, Error::UserNotFound.new(request.url, @name).extend(Representer::Error).to_json
        # end
        #
        # if authorized?
        #   @user.extend(Representer::User::AuthorizedItem)
        # else
        #   @user.extend(Representer::User::Item)
        # end

        @user.extend(Representer::User::Item)
      end

      after do
      end

      # api/users/:name
      get '' do
        @user.to_json
      end

      get '/records' do
        limit   = params['limit'].nil? ? 10 : params['limit'].to_i

        records = params.key?('all') ? @user.records : @user.records.first(limit)

        collection = OpenStruct.new.extend(Representer::Submission::Collection)
        collection.total       = @user.records.count
        collection.submissions = records

        collection.to_json
      end

      get '/records/:record' do
        record = Record[param[:record]]

        collection = OpenStruct.new.extend(Representer::Submission::Item)
      end

      get '/notifications' do
        protected!
        
        collection = OpenStruct.new.extend(Representer::Notification::Collection)
        collection.notifications = @user.notification
        collection.total         = @user.notification.count
        collection.unread        = @user.notification.select {|note| note.note_seen.eql? 'n'}.count
        collection.username      = @user.username

        collection.to_json
      end

      get '/notifications/:notification' do
        id = params[:notification].to_i
        
        notification = Model::Notification[id]

        notification.extend(Representer::Notification::Item).to_json
      end

      post '/notifications/:notification' do
        id = params[:notification].to_i
        n  = Model::Notification[id]
        
        if n.nil?
          status 404
          
          return
        end
        
        if @user.id != n.user_id
          status 401
          return
        end
        
        if params[:unread].nil?
          status 400
          body JSON.dump({ message: "Parameter 'unread' is missing" })
          
          return
        end

        if params[:unread].eql? "true"
          n[:note_seen] = 'n'
        elsif params[:unread].eql? "false"
          n[:note_seen] = 'y'
        end
        
        n.save

        Model::Notification[id].extend(Representer::Notification::Item).to_json
      end

    end

  end
end