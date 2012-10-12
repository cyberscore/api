require 'sinatra/base'

require 'atom/pub'

require 'open-uri'
require 'json'

module Cyberscore
  class Feeds < Sinatra::Base
    
    configure do
    end
    
    before do
      content_type 'application/atom+xml'
    end
    
    get '/' do
    end
    
    get '/news' do " "
      news = JSON.parse(open("http://cs-api.heroku.com/api/news").first)['_embedded']['news']
      
      collection = Atom::Pub::Collection.new(:href => 'http://cyberscore.me.uk/news_archive.php')
      
      news = news.map do |n|
        Atom::Entry.new do |entry|
          entry.title   = n['headline']
          entry.authors << Atom::Person.new(:name => 'Cyberscore Admins')
          entry.updated = Date.parse n['date']
          entry.id      = n['_links']['self']['href']
        end
      end
      
      Atom::Feed.new do |f|
        f.title   = "Cyberscore news"
        f.authors << Atom::Person.new(:name => 'Cyberscore Admins')
        f.links << Atom::Link.new(:href => "http://cyberscore.me.uk/news_archive.php")
        f.entries = news
      end.to_xml
    end
    
  end
end