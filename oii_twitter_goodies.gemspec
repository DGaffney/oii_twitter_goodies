# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oii_twitter_goodies/version'

Gem::Specification.new do |gem|
  gem.name          = "oii_twitter_goodies"
  gem.version       = OIITwitterGoodies::VERSION
  gem.authors       = ["Devin Gaffney"]
  gem.email         = ["itsme@devingaffney.com"]
  gem.description   = %q{OII Twitter Goodies!}
  gem.summary       = %q{Warm goopy Ruby code for people at OII (or anyone really) to quickly get their hands dirty with Twitter data}
  gem.homepage      = "http://oii.ox.ac.uk"
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "mongo_mapper"
  gem.add_development_dependency "bcrypt-ruby"
  gem.add_development_dependency "bson_ext"
  gem.add_development_dependency "oauth"
  gem.add_development_dependency "twitter"
  gem.add_development_dependency "tweetstream"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "hashie"
  gem.add_development_dependency "typhoeus"
  gem.add_development_dependency "json"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
