require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'json'
require 'uri'

# 2015-2021 每个月第一条的一个随机小时的前10条
# 用于演示

ATTRS = %W[id type actor repo org payload public created_at]

namespace :gh do 
  task :import => :environment do 
    (Date.parse("2015-01-01")..Date.parse("2021-11-17")).each do |d|
      next if d.mday != 1
      Retryable.retryable(tries: 5, on: [Timeout::Error, Net::OpenTimeout]) do
        run("#{d.to_s}-#{rand(24)}")
      end
    end
  end
end


def run(date = "2015-01-01-12")
  url = "http://data.gharchive.org/#{date}.json.gz"
  puts "request to url #{url}"
  gz = URI.open(url, open_timeout: 600, read_timeout: 600)
  js = Zlib::GzipReader.new(gz).read
  i = 1
  arr = []
  Yajl::Parser.parse(js) do |event|
    break if i > 2000

    other = event.slice!(*ATTRS)

    ATTRS.each do |attr|
      event[attr] = nil if event[attr].nil?
    end    
    arr << event.merge(other: other)
    #GithubEvent.upsert(event.merge(other: other))
    i = i + 1
  end
  GithubEvent.upsert_all(arr)
end