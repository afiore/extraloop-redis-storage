require 'rubygems'
require 'bundler/setup'
require 'extraloop'
require 'geocoder'
require 'pry'
load '../lib/extraloop/redis-storage.rb'
require './lib/heathrow_arrivals_scraper'
require './lib/models/flight_arrival'



HeathrowArrivalScraper.new.
  set_storage(FlightArrival).
  run
