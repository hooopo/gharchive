require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'json'
require 'uri'

namespace :gh do 
  task :import => :environment do 
    (Date.parse("2015-01-02")..Date.parse("2015-01-10")).each do |d|
      Retryable.retryable(tries: 5, on: [Timeout::Error, Net::OpenTimeout]) do
        run("#{d.to_s}-12")
      end
    end
  end
end


def run(date = "2015-01-01-12")
  url = "http://data.gharchive.org/#{date}.json.gz"
  puts "request to url #{url}"
  gz = URI.open(url, open_timeout: 600, read_timeout: 600)
  js = Zlib::GzipReader.new(gz).read
  Yajl::Parser.parse(js) do |event|
    GithubEvent.upsert(event)
  end
end