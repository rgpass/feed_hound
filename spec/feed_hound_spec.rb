require "spec_helper"
require "feed_hound"

FeedHound::default_debug_level = 1

describe FeedHound do
  it "returns the first rss feed on a page if it exists", vcr: { cassette_name: "feed_hound-salesloft.com" } do
    FeedHound.hunt(domain: "salesloft.com").should == "http://salesloft.com/feed/"
  end

  it "understands atom", vcr: { cassette_name: "feed_hound-atom" } do
    FeedHound.hunt(domain: "bblfish.net/blog/blog.atom").should == "http://bblfish.net/blog/blog.atom"
  end

  it "can follow redirects", vcr: { cassette_name: "feed_hound-www.salesloft.com" } do
    FeedHound.hunt(domain: "www.salesloft.com").should == "http://salesloft.com/feed/"
  end

  it "finds feeds via http://blog.<domain>/ links", vcr: { cassette_name: "feed_hound-blog.domain.com" } do
    FeedHound.hunt(domain: "listrak.com/").should == "http://blog.listrak.com/rss"
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

  context "random findable sites" do
    it "finds desk.com", vcr: { cassette_name: "feed_hound-desk.com" } do
      FeedHound.hunt(domain: "desk.com").should == "http://www.desk.com/blog/feed/"
    end

    it "finds agilityrecovery.com", vcr: { cassette_name: "feed_hound-agilityrecovery.com" } do
      FeedHound.hunt(domain: "agilityrecovery.com").should == "http://www2.agilityrecovery.com/feed/"
    end

    it "finds proximusmobility.com", vcr: { cassette_name: "feed_hound-proximusmobility.com" } do
      FeedHound.hunt(domain: "proximusmobility.com").should == "http://proximusmobility.com/feed/"
    end

    it "finds shoutlet.com", vcr: { cassette_name: "feed_hound-shoutlet.com" } do
      FeedHound.hunt(domain: "shoutlet.com").should == "http://www.shoutlet.com/feed/"
    end

    it "finds rigor.com", vcr: { cassette_name: "feed_hound-rigor.com" } do
      FeedHound.hunt(domain: "rigor.com").should == "http://rigor.com/feed"
    end
  end

  context "strictness" do
    context "strict" do
      it "returns nil for sites with no feed", vcr: { cassette_name: "feed_hound-sendgrid.com" } do
        FeedHound.hunt(domain: "sendgrid.com", strict: true).should be_nil
      end
    end

    context "lax strict" do
      it "returns last candidate for malformed feeds", vcr: { cassette_name: "feed_hound-sendgrid.com" } do
        FeedHound.hunt(domain: "sendgrid.com", strict: false).should == "http://feeds.feedburner.com/sendgrid/CDXr"
      end
    end
  end
end
