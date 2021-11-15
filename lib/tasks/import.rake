require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'json'
require 'uri'

namespace :gh do 
  task :import => :environment do 
    run
  end
end


def run
  gz = URI.open('http://data.gharchive.org/2015-01-01-12.json.gz')
  js = Zlib::GzipReader.new(gz).read
  Yajl::Parser.parse(js) do |event|
    print event
    GithubEvent.upsert(event)
  end
end