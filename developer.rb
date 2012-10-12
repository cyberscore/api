require 'sinatra/base'

module Cyberscore
  class Developer < Sinatra::Base

    configure do
      enable :inline_templates
    end

    get '/' do
"<h1>Hello World</h1>

<p>
  Soon the API will be properly documented here.
</p>
"
    end

    get '/explorer' do
      send_file 'public/hal_browser.html'
    end

  end
end
