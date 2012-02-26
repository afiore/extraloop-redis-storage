require "rubygems"
require "date"
require "extraloop"
require "../lib/extraloop/redis-storage.rb"
require "./lib/models/amazon_review.rb"
require "./lib/scrapers/amazon_review_scraper.rb"

scraper = AmazonReviewScraper.new("0262560992").
  set_storage(AmazonReview).
  run

records = AmazonReview.find :session_id => scraper.session.id
puts "#{records.size} reviews have been created"

