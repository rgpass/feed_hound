# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feed_hound/version'

Gem::Specification.new do |gem|
  gem.name          = "feed_hound"
  gem.version       = FeedHound::VERSION
  gem.authors       = ["Rob Forman"]
  gem.email         = ["rob@robforman.com"]
  gem.description   = %q{FeedHound tracks down RSS feeds for a domain.}
  gem.summary       = %q{FeedHound tracks down RSS feeds for a domain.}
  gem.homepage      = "https://github.com/SalesLoft/feed_hound"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "vcr"
  gem.add_development_dependency "geminabox"
  gem.add_runtime_dependency "faraday"
  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "feedzirra"
end
