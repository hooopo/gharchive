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
    db_repos = YAML.load_file(Rails.root.join("meta/repos/db_repos.yml"))
    db_repos.each do |repo|
      DbRepo.upsert(repo)
    end

    cn_orgs = YAML.load_file(Rails.root.join("meta/orgs/cn_orgs.yml"))
    cn_orgs.each do |org|
      CnOrg.upsert(org)
    end

    puts "Sync cn_orgs -> cn_repos"

    sql = <<-SQL
      WITH tmp AS (
        SELECT repo_id, repo_name, max(cast(ge.id as unsigned)) as max_id 
          FROM github_events as ge 
               JOIN cn_orgs as co on co.id = ge.org_id
      GROUP BY repo_id, repo_name
      ORDER BY 1,2
     ), tmp1 as (
        SELECT repo_id, 
               repo_name, 
               row_number() over(partition by repo_id order by max_id desc) as c
          FROM tmp
      )

      SELECT repo_id as id, 
             repo_name as name
        FROM tmp1 
       WHERE c = 1 AND repo_id is not null 
    SQL

    results = ActiveRecord::Base.connection.select_all(sql).send(:hash_rows)
    CnRepo.upsert_all(results)

    cn_repos = YAML.load_file(Rails.root.join("meta/repos/cn_repos.yml"))
    cn_repos.each do |repo|
      CnRepo.upsert(repo)
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
