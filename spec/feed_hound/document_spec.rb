require "spec_helper"
require "feed_hound"

FeedHound::default_debug_level = 1

describe FeedHound::Document do
  describe "#blog_links" do
    it "finds feedburner links", vcr: { cassette_name: "feed_hound_document-sendgrid.com" } do
      FeedHound::Document.new(:url => "http://sendgrid.com").blog_links.should include("http://feeds.feedburner.com/sendgrid/CDXr")
    end
  end
end
