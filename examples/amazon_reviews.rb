require "rubygems"
require "extraloop"
require "date"
require "./lib/amazon_review_scraper.rb"
require "../lib/extraloop/redis-storage.rb"

class AmazonReview < ExtraLoop::Storage::Record
  attribute :title
  attribute :rank
  attribute :date

  def validate
    assert (0..5).include?(rank.to_i), "Rank not in range"
  end
end

scraper = AmazonReviewScraper.new("0262560992").
  set_storage(AmazonReview).
  run

records = AmazonReview.find :session_id => scraper.session.id
puts "#{records.size} reviews have been created"

