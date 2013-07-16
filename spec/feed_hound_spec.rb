require "spec_helper"
require "feed_hound"

FeedHound::default_debug_level = 1

describe FeedHound do
  it "returns the first rss feed on a page if it exists", vcr: { cassette_name: "feed_hound-salesloft.com" } do
    FeedHound.hunt(domain: "salesloft.com").should == "http://feeds.feedburner.com/salesloft"
  end

  it "understands atom", vcr: { cassette_name: "feed_hound-atom" } do
    FeedHound.hunt(domain: "atomenabled.org").should == "http://www.atomenabled.org/atom.xml"
  end

  it "can follow redirects", vcr: { cassette_name: "feed_hound-www.salesloft.com" } do
    FeedHound.hunt(domain: "www.salesloft.com").should == "http://feeds.feedburner.com/salesloft"
  end

  it "finds feeds via http://blog.<domain>/ links", vcr: { cassette_name: "feed_hound-pgi.com" } do
    FeedHound.hunt(domain: "pgi.com").should == "http://blog.pgi.com/feed/"
  end

  it "finds feeds via http://<domain>/blog links", vcr: { cassette_name: "feed_hound-thewaltdisneycompany.com" } do
    FeedHound.hunt(domain: "thewaltdisneycompany.com").should == "https://thewaltdisneycompany.com/blog/feed"
  end

  it "finds feeds via crappy title=RSS linkage", vcr: { cassette_name: "feed_hound-boomtownroi.com" }do
    FeedHound.hunt(domain: "boomtownroi.com").should == "http://feeds.boomtownroi.com/boomtownroi"
  end

  it "finds <company>.hubspot.com blogs", vcr: { cassette_name: "feed_hound-vorsight.com" } do
    FeedHound.hunt(domain: "vorsight.com").should == "http://marketing.vorsight.com/CMS/UI/Modules/BizBlogger/rss.aspx?tabid=249282&moduleid=454382&maxcount=25"
  end

  it "finds via feed:// href", vcr: { cassette_name: "feed_hound-liaison.com" } do
    FeedHound.hunt(domain: "liaison.com").should == "http://liaison.com/Feeds/liaison-blog"
  end

  it "will try any link from feedburner as a last resort", vcr: { cassette_name: "feed_hound-sendgrid.com" } do
    FeedHound.hunt(domain: "sendgrid.com").should == "http://feeds.feedburner.com/sendgrid/CDXr"
  end

  it "returns nil for sites with no rss feed", vcr: { cassette_name: "feed_hound-cbeyond.com" } do
    FeedHound.hunt(domain: "cbeyond.com").should == nil
  end

  context "random findable sites" do
    it "finds desk.com", vcr: { cassette_name: "feed_hound-desk.com" } do
      FeedHound.hunt(domain: "desk.com").should == "http://www.desk.com/blog/feed/"
    end

    it "finds agilityrecovery.com", vcr: { cassette_name: "feed_hound-agilityrecovery.com" } do
      FeedHound.hunt(domain: "agilityrecovery.com").should == "http://www2.agilityrecovery.com/news.rss"
    end

    it "finds proximusmobility.com", vcr: { cassette_name: "feed_hound-proximusmobility.com" } do
      FeedHound.hunt(domain: "proximusmobility.com").should == "http://proximusmobility.com/feed/"
    end

    it "finds shoutlet.com", vcr: { cassette_name: "feed_hound-shoutlet.com" } do
      FeedHound.hunt(domain: "shoutlet.com").should == "http://www.shoutlet.com/feed/"
    end

    it "finds blinqmedia.com", vcr: { cassette_name: "feed_hound-blinqmedia.com" } do
      FeedHound.hunt(domain: "blinqmedia.com").should == "http://blinqmedia.com/feed/"
    end
  end
end