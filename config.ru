require 'bundler/setup'

require 'rack'
require 'rack/contrib'
require 'rack/cache'
require 'rack/cors'

require './api'


use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*', :headers => :any
  end
end
use Rack::Deflater
use Rack::JSONP
use Rack::ShowExceptions


run Cyberscore::API.new