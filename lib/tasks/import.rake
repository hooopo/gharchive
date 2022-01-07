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

  task :db_repos_csv => :environment do 
    file = "#{Rails.root}/tmp/db_repos.csv"
     
    table = DbRepo.all
     
    CSV.open(file, 'w' ) do |writer|
      writer << table.first.attributes.map { |a,v| a }
      table.each do |s|
        writer << s.attributes.map { |a,v| v }
      end
    end
  end

  task :cn_repos_csv => :environment do 
    file = "#{Rails.root}/tmp/cn_repos.csv"
     
    table = CnRepo.all
     
    CSV.open(file, 'w' ) do |writer|
      writer << table.first.attributes.map { |a,v| a }
      table.each do |s|
        writer << s.attributes.map { |a,v| v }
      end
    end
  end

  task :cn_orgs_csv => :environment do 
    file = "#{Rails.root}/tmp/cn_orgs.csv"
     
    table = CnOrg.all
     
    CSV.open(file, 'w' ) do |writer|
      writer << table.first.attributes.map { |a,v| a }
      table.each do |s|
        writer << s.attributes.map { |a,v| v }
      end
    end
  end

  task :import => :environment do
    from = ENV['FROM'] || '2021-12-17'
    to   = ENV['TO'] || Time.now.to_date.to_s

    (Date.parse(from)..Date.parse(to)).each do |d|
      (0..23).each do |hour|
        filename = "#{d}-#{hour}.json.gz"
        next if filename == '2016-10-21-18.json.gz'
        next if filename == "2020-03-05-22.json.gz"
        next if filename == "2020-06-10-12.json.gz"
        puts "Start import gharchive event data from #{from} to #{to} ..."

        hour_str = '%02d' % hour
        start_time = "#{d.to_s} #{hour_str}:00:00"
        end_time   = "#{d.to_s} #{hour_str}:59:59"
        binding.pry
        loop do
          n = GithubEvent.where(created_at: (start_time..end_time)).limit(100000).delete_all
          break if n < 100000
        end

        importer = Importer.new(filename)
        importer.run!
      end
    end
  end
end
