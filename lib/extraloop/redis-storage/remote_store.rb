# Base class for pushing Extraloop datasets from the local Redis
# store to remote ones (e.g. Google Fusion tables, Buzzdata, Cartodb)

$: << path = File.dirname(__FILE__) + '/remote_store'
Dir["#{path}/*.rb"].each { |store_adapter| require store_adapter }


class ExtraLoop::Storage::RemoteStore
  def self.get_transport(datastore, credentials, options={})
    classname = datastore.to_s.gsub(/^.|_./) { |chars| chars.split("").last.upcase }
    ExtraLoop::Storage.const_get(classname).new(credentials, options) if ExtraLoop::Storage.const_defined?(classname)
  end
end
