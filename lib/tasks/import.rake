require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'json'
require 'uri'
require_relative '../importer'

namespace :gh do 
  task :import => :environment do
    cache_dir = ENV['CACHE_DIR'] || Rails.root.join("cache/gharchives").to_s
    FileUtils.mkdir_p cache_dir

    dump_dir = ENV["DUMP_DIR"] || Rails.root.join('dumping-v3').to_s
    FileUtils.mkdir_p dump_dir
    
    from = ENV['FROM'] || ImportLog.order("id desc").first&.date_str || '2016-01-01'
    to   = ENV['TO'] || Time.now.to_date.to_s
    
    # Simulate the generation of tidb dumping, export the file directory structure and schema definition required by tidb-lightning
    TidbDumpling.new(dump_dir, ENV['TARGET_DB'] || ActiveRecord::Base.connection.current_database).run

    (Date.parse(from)..Date.parse(to)).each do |d|
      (0..23).each do |hour|
        filename = "#{d}-#{hour}.json.gz"
        next if filename == '2016-10-21-18.json.gz'
        next if filename == "2020-03-05-22.json.gz"
        puts "Start import gharchive event data from #{from} to #{to} ..."

        importer = Importer.new(filename, cache_dir)
        importer.run!
      end
    end
  end
end
