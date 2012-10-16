require 'bundler/setup'

require 'rack'
require 'rack/contrib'
require 'rack/cache'

require './api'


use Rack::Deflater
use Rack::JSONP
use Rack::ShowExceptions


run Cyberscore::API.new