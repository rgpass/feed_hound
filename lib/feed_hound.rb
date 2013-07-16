require_relative "./feed_hound/tracker"
require_relative "./feed_hound/version"

module FeedHound
  DEBUG_LEVEL = 0

  def self.hunt(options)
    FeedHound::Tracker.new(options).hunt
  end
end