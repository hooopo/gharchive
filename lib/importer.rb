class Importer
  attr_reader :filename, :url, :cache_dir, :batch_at, :import_log, :events, :cache_filename, :raw_events, :dump_dir

  ATTRS = %W[id type actor repo org payload public created_at]
  JSON_ATTRS = %w[actor repo org payload other labels]
  BOOL_ATTRS = %w[public github_staff pr_merged locked pr_draft]
  EXTRACT_ATTRS = %w[
    other is_oss_db repo_name
    repo_id language additions deletions action actor_id actor_login actor_location 
    commit_id comment_id body number org_id org_login
    labels state locked closed_at comments milestone
    pr_merged_at pr_draft pr_merged pr_changed_files  pr_review_comments
    github_staff pr_or_issue_id email_domain event_day event_month event_year
  ]

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
    "scylladb/scylla",
    "apache/hadoop",
    "apache/couchdb"
  ]

  DB_REPO_CACHE = DB_REPO.map{|k| [k, 1]}.to_h


  def initialize(filename, cache_dir = nil)
    @filename        = filename
    @cache_dir       = cache_dir || ENV['CACHE_DIR'] || Rails.root.join("cache/gharchives/").to_s
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
      # site_admin: payload.pull_request.base.user.site_admin
      github_staff = event.dig("payload", "pull_request", "base", "user", "site_admin") || 
        event.dig("payload", "issue", "user", "site_admin")
      
      # x.payload.pull_request.merged
      pr_merged = event.dig("payload", "pull_request", "merged")

      # x.payload.[pull_request/issue].state
      state = event.dig("payload", "pull_request", "state") ||
        event.dig("payload", "issue", "state")

      # x.payload.[pull_request/issue].locked
      locked = event.dig("payload", "pull_request", "locked") || 
        event.dig("payload", "issue", "locked")

       # x.payload.[pull_request/issue].closed_at
      closed_at = event.dig("payload", "pull_request", "closed_at") ||
        event.dig("payload", "issue", "closed_at")

      # x.payload.pull_request.merged_at
      pr_merged_at = event.dig("payload", "pull_request", "merged_at") 

      milestone = event.dig("payload", "pull_request", "milestone", "title") ||
        event.dig("payload", "issue", "milestone", "title")

      comments = event.dig("payload", "pull_request", "comments") ||
        event.dig("payload", "issue", "comments")

      pr_or_issue_id = event.dig("payload", "pull_request", "id") ||
        event.dig("payload", "issue", "id")

      pr_changed_files = event.dig("payload", "pull_request", "pr_changed_files")
      pr_review_comments = event.dig("payload", "pull_request", "pr_review_comments")
      pr_draft = event.dig("payload", "pull_request", "draft")

      labels = event.dig("payload", "issue", "labels")
      labels.map! {|x| x["name"] } if labels
      
      # payload.commits[0].author.email
      email_domain = event.dig("payload", "commits", 0, "author", "email")
      email_domain = email_domain.split("@", 2).last if email_domain

      date = event["created_at"].match(/((\d{4})-\d{2})-\d{2}/)
      event_day = date[0]
      event_month = date[1]
      event_year = date[2]

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
        "org_login" => org_login,
        "github_staff" => github_staff,
        "pr_merged" => pr_merged,
        "state" => state,
        "locked" => locked,
        "pr_merged_at" => pr_merged_at,
        "closed_at" => closed_at,
        "milestone" => milestone,
        "comments" => comments,
        "pr_or_issue_id" => pr_or_issue_id,
        "pr_changed_files" => pr_changed_files,
        "pr_review_comments" => pr_review_comments,
        "pr_draft" => pr_draft,
        "labels" => labels,
        "email_domain" => email_domain,
        "event_day" => event_day,
        "event_month" => event_month,
        "event_year" => event_year
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
      BOOL_ATTRS.each do |attr|
        event[attr] = 1 if event[attr]
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