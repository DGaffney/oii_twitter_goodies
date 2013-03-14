# OII Twitter Goodies

This set of libraries, functions, and monkey patches to existing Twitter gems aims to make the work that Oxford Internet Institute's various faculty and staff undertakes as simple as possible. Have fun.

## Installation

Add this line to your application's Gemfile:

    gem 'oii_twitter_goodies'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oii_twitter_goodies

## Usage

Although this is *just* a gem, it has a few notable dependencies depending on what you're playing with:

1. If you're using the OIITwitter class to collect REST API data from Twitter, you're going to need:
  a. MongoDB installed locally, running on port 27017 (this is the default port). Thankfully, MongoDB is relatively easy to install
  b. MongoMapper, the Ruby Gem that is responsible for tying between MongoDB's internals and Ruby code (the term for this type of Gem is ORM - may want to read up on that if you're ever bored).
  c. Twitter and TweetStream (these are the two principle Gems used for Twitter data collection).
2. What you get:
  a. OIITwitter: A library of several functions that cover most of the bases of data collection that any of you guys are going to need (currently supports grabbing sets of tweets, users, follower/friend IDs, and egonets (and caches it!))
  b. OIITweetStream: A library that wraps TweetStream's streaming API functionality, and sets up a best-practices database for storing data from the stream.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
