module Cyberscore
  class API < Sinatra::Base

    get '/rels/' do
      "Relations"
    end

    get '/rels/records' do
      "<h1>Some records.</h1>"
    end

    get '/rels/dashboard' do
      "A dashboard"
    end

    get '/rels/rankbuttons' do
      "A rankbutton"
    end

  end
end
