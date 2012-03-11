require "rubygems"
require "json"
require "yaml"
require "rubygems"
require "redis"
require "ohm"
require "ohm/contrib"
require "extraloop"

begin
  gem "fusion_tables", "~> 0.3.1"
  require "fusion_tables"
rescue Gem::LoadError
end


base_path = File.realpath(File.dirname(__FILE__))
$: << "#{base_path}"

require "scraper_base"

module ExtraLoop
  module Storage
    VERSION ||= "0.0.7"

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
autoload :Etc, 'etc'

base_path << "/redis-storage"

ExtraLoop::Storage.autoload :Record, "#{base_path}/record.rb"
ExtraLoop::Storage.autoload :ScrapingSession, "#{base_path}/scraping_session.rb"
ExtraLoop::Storage.autoload :Model,  "#{base_path}/model.rb"
ExtraLoop::Storage.autoload :DatasetFactory,  "#{base_path}/dataset_factory.rb"
ExtraLoop::Storage.autoload :RemoteStore, "#{base_path}/remote_store.rb"

