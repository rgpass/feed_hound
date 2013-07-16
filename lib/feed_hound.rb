require "feed_hound/document"
require "feed_hound/tracker"
require "feed_hound/version"

module FeedHound
  @@default_debug_level = 0

  def self.default_debug_level=(level)
    @@default_debug_level = level
  end

  def self.default_debug_level
    @@default_debug_level
  end

  def self.hunt(options)
    FeedHound::Tracker.new(options).hunt
  end
end