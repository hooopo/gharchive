class Importer
  attr_reader :filename, :url, :cache_dir, :batch_at, :import_log, :events, :cache_filename, :raw_events

  ATTRS = %W[id type actor repo org payload public created_at]


  def initialize(filename, dir = nil)
    @filename        = filename
    @cache_dir       = dir || ENV['DIR'] || Rails.root.join("cache/gharchives/").to_s
    @cache_filename  = File.join(cache_dir, filename)
    @url             = "http://data.gharchive.org/#{filename}"
    @batch_at        = Time.now
    @import_log      = ImportLog.create!(filename: filename, start_batch_at: batch_at)
    @json_stream     = nil
    @events          = []
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
      @events << event.merge(other: other)
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
    puts "start insert #{events.count} records into DB ..."
    events.each do |event|
      GithubEvent.upsert(event)
    end
  end
end