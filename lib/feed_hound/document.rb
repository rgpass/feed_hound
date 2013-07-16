require "feedzirra"
require "faraday"

module FeedHound
  class Document
    CONTENT_TYPES = [
      'application/x.atom+xml',
      'application/atom+xml',
      'application/xml',
      'text/xml',
      'application/rss+xml',
      'application/rdf+xml',
    ]

    attr_reader :url, :debug_level

    def initialize(options)
      @url = options.fetch(:url)
      @debug_level = options.fetch(:debug_level, FeedHound::default_debug_level)
    end

    def is_rss?
      feed = Feedzirra::Feed.fetch_and_parse(url)
      feed != nil || feed == 0
    end

    def doc
      @doc ||= Nokogiri::HTML(html)
    end

    def html
      @html ||= response.body
    end

    def response
      @response ||= conn.get(url)
    end

    def conn
      @conn ||= Faraday.new
    end

    def redirect?
      [301, 302].include?(response.status)
    end

    def redirect_location
      fqdn(response.headers[:location])
    end

    def rss_references
      links = doc.css("head link").map{ |e| { type: e.attribute("type") ? e.attribute("type").value.strip : "", href: e.attribute("href") ? e.attribute("href").value.strip : "" } }
      rss_links = links.select{ |link| CONTENT_TYPES.include?(link[:type]) }
      rss_links.map{ |link| link[:href] }
    end

    def blog_links
      anchors = doc.css("a").map{ |element| {
          type: element.attribute("type") ? element.attribute("type").value.strip : "",
          href: element.attribute("href") ? element.attribute("href").value.strip : "",
          title: element.attribute("title") ? element.attribute("title").value.strip : "",
      }}

      uri = URI.parse(url)
      domain = truncate_subdomain

      blog_links  = []
      anchors.each { |anchor|  puts "anchor #{anchor}" } if debug_level >= 2

      anchors.each do |anchor|
        if anchor[:href].start_with?("feed://")
          blog_links << fqdn(anchor[:href].gsub("feed://", "http://"))
        end
      end

      anchors.each do |anchor|
        if anchor[:href] == "http://blog.#{domain}/" || anchor[:href] == "https://blog.#{domain}/"
          blog_links << fqdn(anchor[:href])
        end

        if anchor[:href] =~ /\/blog$/ || anchor[:href] =~ /\/blog\/$/
          blog_links << fqdn(anchor[:href])
        end

        if anchor[:href] == "/blog" || anchor[:href] == "blog"
          blog_links << fqdn(anchor[:href])
        end

        if anchor[:href] == "/blog/feed"
          blog_links << fqdn(anchor[:href])
        end

        if anchor[:title] == "RSS"
          blog_links << fqdn(anchor[:href])
        end
      end

      anchors.each do |anchor|
        if anchor[:href].include?("feeds.feedburner.com")
          blog_links << fqdn(anchor[:href])
        end
      end

      blog_links.uniq!
      puts "DEBUG  - blog related links: #{blog_links}" if debug_level >= 1
      blog_links
    end

    def truncate_subdomain
      uri = URI.parse(url)
      uri.host.split(".").count > 2 ? uri.host.split(".", 2).last : uri.host
    end

    def fqdn(fqdn_url)
      if url_relative?(fqdn_url)
        uri = URI.parse(url)
        if fqdn_url[0] == "/"
          fqdn_url = "#{uri.scheme}://#{uri.host}#{fqdn_url}"
        else
          fqdn_url = "#{uri.scheme}://#{uri.host}/#{fqdn_url}"
        end
      end

      fqdn_url
    end

    def url_relative?(relative_url)
      uri = URI.parse(relative_url)
      uri.host == nil
    end
  end
end