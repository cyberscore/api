module Cyberscore
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
        @user = Model::User.find(:username => params['name'])
      end

      after do
      end

      # api/users/:name
      get '' do
        return {error: 'no user found'}.to_json if @user.nil?

        @user.extend(Representer::User::Item).to_json
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

        collection = OpenStruct.extend(Representer::Submission::Item)
      end

    end

  end
end