require_relative "./document"

class FeedHound::Tracker
  MAX_HUNT_DEPTH = 4

  attr_reader :domain, :debug_level

  def initialize(options)
    @domain = options.fetch(:domain)
    @debug_level = options.fetch(:debug_level, FeedHound::DEBUG_LEVEL)
    @depth = 0
    @visited_urls = []
  end

  def hunt
    resolve_rss("http://#{domain}")
  end

  protected

  def resolve_rss(url)
    puts "DEBUG hunt depth #{@depth}: #{url}" if debug_level >= 1
    return nil if url.nil?

    doc = FeedHound::Document.new(url: url, debug_level: debug_level)
    if doc.is_rss?
      puts "DEBUG  - found RSS" if debug_level >= 1
      return url
    end

    # Keep looking
    @depth += 1
    if @depth > MAX_HUNT_DEPTH
      puts "DEBUG MAX_HUNT_DEPTH (#{MAX_HUNT_DEPTH}) exceeded" if debug_level >= 1
      return nil
    end

    if doc.redirect?
      puts "DEBUG  - redirect to #{doc.redirect_location}" if debug_level >= 1
      return resolve_rss(doc.redirect_location)
    elsif doc.rss_references.count > 0
      puts "DEBUG  - found reference to RSS in header" if debug_level >= 1
      return resolve_rss(first_unvisited(doc.rss_references))
    elsif doc.blog_links.count > 0
      return resolve_rss(first_unvisited(doc.blog_links))
    end

    puts "DEBUG search exhausted. Stopping." if debug_level >= 1
    return nil
  end

  def first_unvisited(urls)
    url = urls.shift
    while @visited_urls.include?(url) do
      url = urls.empty? ? nil : urls.shift
    end

    @visited_urls << url unless url.nil?
    url
  end
end