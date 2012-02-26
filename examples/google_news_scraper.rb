require "pry"
require "rubygems"
require "../lib/extraloop/redis-storage.rb"


google_news_scraper = ExtraLoop::IterativeScraper.new("https://www.google.com/search?tbm=nws&q=Egypt").
  set_iteration(:start, (1..101).step(10)).
  loop_on("h3") { |nodes| nodes.map(&:parent) }.
    extract(:title, "h3.r a").
    extract(:url, "h3.r a", :href).
    extract(:source, "br") { |node| node.next.text.split("-").first }.
  set_storage(:GoogleNewsStory).
  run

puts "#{GoogleNewsStory.all.to_a.size} news stories fetched..."


