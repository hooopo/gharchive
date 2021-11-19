require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'json'
require 'uri'
require_relative '../importer'

namespace :gh do 
  task :import => :environment do
    cache_dir = Rails.root.join("cache/gharchives").to_s
    FileUtils.mkdir_p cache_dir

    from = ENV['FROM'] || '2015-01-01'
    to   = ENV['TO'] || Time.now.to_date.to_s

    (Date.parse(from)..Date.parse(to)).each do |d|
      (0..23).each do |hour|
        filename = "#{d}-#{hour}.json.gz"
        puts "Start import gharchive event data from #{from} to #{to} ..."
        
        importer = Importer.new(filename, cache_dir)
        importer.run!
      end
    end
  end
end