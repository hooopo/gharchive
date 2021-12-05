require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'json'
require 'uri'
require 'yaml'
require_relative '../importer'

namespace :gh do 
  task :load_meta => :environment do 
    db_repos = YAML.load_file(Rails.root.join("db_repos.yml"))
    db_repos.each do |r|
      name = r.keys.first 
      id = r.dig(name, 'id')
      DbRepo.upsert(id: id, name: name)
    end
  end

  task :fix => :environment do 
    conn = ActiveRecord::Base.connection.raw_connection
    loop do
      begin
        conn.query(<<~SQL)
          update github_events 
          set event_month = date_format(created_at, '%Y-%m-01'), 
              event_day = date_format(created_at, '%Y-%m-%d') 
          where event_month in ('1','2','3','4','5','6','7','8','9','10','11','12') 
          limit 200000
        SQL
      rescue Mysql2::Error::TimeoutError
        retry
      end
      puts "affected_rows #{conn.affected_rows}"
      break if conn.affected_rows < 200000
    end
  end
  
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
        next if filename == "2020-06-10-12.json.gz"
        puts "Start import gharchive event data from #{from} to #{to} ..."

        importer = Importer.new(filename, cache_dir)
        importer.run!
      end
    end
  end
end
