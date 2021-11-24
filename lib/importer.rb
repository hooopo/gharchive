class Importer
  attr_reader :filename, :url, :cache_dir, :batch_at, :import_log, :events, :cache_filename, :raw_events, :dump_dir

  ATTRS = %W[id type actor repo org payload public created_at]
  JSON_ATTRS = %w[actor repo org payload other]
  EXTRACT_ATTRS = %w[other is_oss_db repo_name repo_id language additions deletions action actor_id actor_login actor_location commit_id comment_id body number org_id org_login]

  DB_REPO = [
    "elastic/elasticsearch",
    "clickhouse/clickhouse", 
    "apache/spark", 
    "pingcap/tidb",
    "cockroachdb/cockroach", 
    "prometheus/prometheus", 
    "mongodb/mongo",
    "trinodb/trino", 
    "tikv/tikv", 
    "redis/redis",
    "apache/lucene-solr",
    "apache/hbase", 
    "prestodb/presto", 
    "facebook/rocksdb", 
    "apache/druid",
    "apache/hive",
    "percona/percona-server", 
    "yugabyte/yugabyte-db",
    "apache/lignite",
    "apache/incubator-doris",
    "citusdata/citus",
    "timescale/timescaledb",
    "apache/kylin",
    "greenplum-db/gpdb",
    "alibaba/oceanbase",
    "influxdata/influxdb",
    "vesoft-inc/nebula",
    "scylladb/scylla"
  ]

  DB_REPO_CACHE = DB_REPO.map{|k| [k, 1]}.to_h


  def initialize(filename, dir = nil)
    @filename        = filename
    @cache_dir       = dir || ENV['DIR'] || Rails.root.join("cache/gharchives/").to_s
    @cache_filename  = File.join(cache_dir, filename)
    @url             = "http://data.gharchive.org/#{filename}"
    @batch_at        = Time.now
    @import_log      = ImportLog.create!(filename: filename, start_batch_at: batch_at)
    @json_stream     = nil
    @events          = []
    @dump_dir        = ENV['DUMP_DIR'] || Rails.root.join("dumping-v3").to_s
  end

  def run!
    import_log.update(start_download_at: Time.now)
    download!
    import_log.update(end_download_at: Time.now)
    parse!
    import_log.update(start_import_at: Time.now)
    import!
    import_log.update(end_import_at: Time.now)
  end

  def parse!
    puts "start parse json data ..."
    Yajl::Parser.parse(@json_stream) do |event|
      other = event.slice!(*ATTRS)

      ATTRS.each do |attr|
        event[attr] = nil if event[attr].nil?
      end
      repo_id = event.dig("repo", "id")
      repo_name = event.dig("repo", "name")

      is_oss_db = DB_REPO_CACHE[repo_name]
      language = event.dig("payload", "pull_request", "base", "repo", "language")
      actor_id = event.dig("actor", 'id')
      actor_login = event.dig("actor", "login")
      actor_location = event.dig("actor", "location")
      action = event.dig("payload", "action")
      additions = event.dig("payload", "pull_request", "additions")
      deletions = event.dig("payload", "pull_request", "deletions")
      commit_id = event.dig("payload", "comment", "commit_id")
      comment_id = event.dig("payload", "comment", "id")
      org_id = event.dig("org", "id") if event["org"]
      org_login = event.dig("org", "login") if event["org"]
      body = event.dig("payload", "review", "body") || event.dig("payload", "comment", "body") || event.dig("payload", "issue", "body") || event.dig("payload", "pull_request", "body") || event.dig("payload", "release", "body") # payload.review.body // .payload.comment.body // .payload.issue.body? // .payload.pull_request.body? // .payload.release.body? // null,
      body = body[0..500] if body
      number = event.dig("payload", "issue", "number") || event.dig("payload", "pull_request", "number") || event.dig("payload", "number") # payload.issue.number? // .payload.pull_request.number? // .payload.number?
      event["payload"] = {}
      event["actor"] = {}
      event["repo"] = {}
      event["org"] = {}
      @events << event.merge(
        "other" => other, 
        "repo_id" => repo_id, 
        "repo_name" => repo_name,
        "is_oss_db" => is_oss_db,
        "language" => language,
        "actor_id" => actor_id,
        "actor_login" => actor_login,
        "actor_location" => actor_location,
        "additions" => additions,
        "deletions" => deletions,
        "action" => action,
        "commit_id" => commit_id,
        "number" => number,
        "org_id" => org_id,
        "org_login" => org_login
      )
    end
  end

  def download!
    if File.exists?(cache_filename)
      puts "start downloading, cache get, use #{cache_filename}"
      gz = File.open(cache_filename) 
    else
      puts "start downloading, cache miss, request url: #{url}"
      Retryable.retryable(tries: 5, on: [Timeout::Error, Net::OpenTimeout, OpenURI::HTTPError]) do
        gz = URI.open(url, open_timeout: 600, read_timeout: 600)
      end
    end

    @json_stream = Zlib::GzipReader.new(gz).read
  end

  def import!
    if ENV['upsert_all']
      upsert_all
    elsif ENV['insert_all']
      dumpling
    else
      dumpling
    end
  end

  def dumpling
    puts "start dump #{events.count} records to csv file ..."
    events.map! do |event|
      JSON_ATTRS.each do |attr|
        event[attr] = event[attr].to_json if event[attr]
      end
      event
    end
    
    tidb_dumpling = TidbDumpling.new(dump_dir, ENV['TARGET_DB'] || ActiveRecord::Base.connection.current_database)
    tidb_dumpling.save_table_rows_to_csv2(import_log.date_id, 'github_events', ATTRS + EXTRACT_ATTRS, events)
  end

  def upsert_all
    puts "start insert #{events.count} records into DB using upsert_all ..."
    GithubEvent.upsert_all(events)
  end

  def insert_all
    puts "start insert #{events.count} records into DB using insert_all ..."
    GithubEvent.insert_all(events)
  end
end