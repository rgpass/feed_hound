# FeedHound

FeedHound tracks down an RSS feed for a given domain.

First it checks for RSS links in the header. If there aren't any, its uses conventional hints from <a> tags (blog.domain.com and domain.com/blog) and follows links to find the blog. Finally, it opens the feed url and confirm that its in a format we (Feedzirra more specifically) can read.

## Installation

Add this line to your application's Gemfile:

    gem 'feed_hound'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feed_hound

## Usage

```ruby
> FeedHound.hunt(domain: "salesloft.com", debug: true)
DEBUG hunt depth 0: http://listrak.com
DEBUG  - redirect to http://www.listrak.com/
DEBUG hunt depth 1: http://www.listrak.com/
DEBUG  - blog_links: ["http://blog.listrak.com/", "http://blog.listrak.com/"]
DEBUG hunt depth 2: http://blog.listrak.com/
DEBUG  - found reference to rss
DEBUG hunt depth 3: http://blog.listrak.com/rss
DEBUG  - found RSS
=> "http://feeds.feedburner.com/salesloft"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
