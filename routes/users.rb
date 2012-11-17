module Cyberscore
  class API < Sinatra::Base

    get '/users' do
      if params['username']
        username = params.delete 'username'
        url = "/users/#{username}"

        redirect to("/users/#{username}")
      end

      users = Model::User.order(:user_id.desc).first(5)

      collection = OpenStruct.new.extend(Representer::User::Collection)
      collection.users_count = Model::User.count
      collection.users       = Model::User.order(:user_id.desc).first(5)

      collection.to_json
    end

    get '/users/:name' do
      user = if params['name'].match(/\A\d+\z/)
        Model::User.find(:user_id => params['name'])
      else
        Model::User.find(:username => params['name'])
      end

      return {error: 'no user found'}.to_json if user.nil?

      user.extend(Representer::User::Item).to_json
    end

    get '/users/:name/records' do
      user = Model::User.find(:username => params['name'])
      limit = params['limit'].nil? ? 10 : params['limit'].to_i

      collection = OpenStruct.new.extend(Representer::Submission::Collection)
      collection.total       = user.records.count
      collection.submissions = params.key?('all') ?
        user.records : user.records.first(limit)

      collection.to_json
    end

    get '/users/:name/games' do
    end

    get '/users/:name/games/:game' do
    end

    get '/users/:name/:game/:group' do
    end

    get '/games/:game?username=:user' do
      puts "#{user} : #{game}"
    end
  end
end