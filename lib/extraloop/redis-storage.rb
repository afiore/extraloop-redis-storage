require "json"
require "rubygems"
require "redis"
require "ohm"
require "ohm/contrib"
require "extraloop"

base_path = File.realpath(File.dirname(__FILE__))
$: << "#{base_path}"

require "scraper_base"

module ExtraLoop
  module Storage
    VERSION ||= "0.0.1"

    def self.connect(*args)
      Ohm.connect(*args)
    end

    # Tries to automatically locate the models directory and load all ruby files within in
    def self.autoload_models(dirname='models')
      Dir["**/**#{dirname}/*.rb"].each { |path| require "./#{path}" }
    end
  end
end

autoload :CSV, 'csv'
ExtraLoop::Storage.autoload :Record, "#{base_path}/redis-storage/record.rb"
ExtraLoop::Storage.autoload :ScrapingSession, "#{base_path}/redis-storage/scraping_session.rb"
ExtraLoop::Storage.autoload :Model,  "#{base_path}/redis-storage/model.rb"
ExtraLoop::Storage.autoload :DatasetFactory,  "#{base_path}/redis-storage/dataset_factory.rb"


