class Importer
  attr_reader :filename, :url, :cache_dir, :batch_at, :import_log, :events, :cache_filename, :raw_events, :dump_dir

  ATTRS = %W[id type actor repo org payload public created_at]
  JSON_ATTRS = %w[actor repo org payload other]
  EXTRACT_ATTRS = %w[other is_oss_db repo_name repo_id]

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
    "vesoft-inc/nebula"
  ]

  DB_REPO_CACHE = DB_REPO.map{|k| [k, true]}.to_h


  def initialize(filename, dir = nil)
    @filename        = filename
    @cache_dir       = dir || ENV['DIR'] || Rails.root.join("cache/gharchives/").to_s
    @cache_filename  = File.join(cache_dir, filename)
    @url             = "http://data.gharchive.org/#{filename}"
    @batch_at        = Time.now
    @import_log      = ImportLog.create!(filename: filename, start_batch_at: batch_at)
    @json_stream     = nil
    @events          = []
    @dump_dir        = ENV['DUMP_DIR'] || Rails.root.join("dumping").to_s
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
      @events << event.merge(
        "other" => other, 
        "repo_id" => repo_id, 
        "repo_name" => repo_name,
        "is_oss_db" => is_oss_db
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
    tidb_dumpling.save_table_rows_to_csv2(import_log.id, 'github_events', ATTRS + EXTRACT_ATTRS, events)
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