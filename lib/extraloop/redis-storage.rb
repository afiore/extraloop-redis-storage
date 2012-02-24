require "json"
require "rubygems"
require "redis"
require 'pry'
require "ohm"
require "ohm/contrib"
require "extraloop"

base_path = File.realpath(File.dirname(__FILE__))
$: << "#{base_path}"
require "scraper_base"



module ExtraLoop
  module Storage
    VERSION ||= "0.0.1"

    class << self
      def connect(*args)
        Ohm.connect(*args)
      end
    end
  end
end

ExtraLoop::Storage.autoload :Record, "#{base_path}/redis-storage/record.rb"
ExtraLoop::Storage.autoload :ScrapingSession, "#{base_path}/redis-storage/scraping_session.rb"
ExtraLoop::Storage.autoload :Model,  "#{base_path}/redis-storage/model.rb"
ExtraLoop::Storage.autoload :DatasetFactory,  "#{base_path}/redis-storage/dataset_factory.rb"


