require 'bundler/setup'

require 'rack'
require 'rack/contrib'
require 'rack/cache'

require './developer'
require './api'
require './feeds'


use Rack::Deflater
use Rack::JSONP
use Rack::ShowExceptions


map "/"      do run Cyberscore::Developer end
map "/api"   do run Cyberscore::API       end
map "/feeds" do run Cyberscore::Feeds     end
