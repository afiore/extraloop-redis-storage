class ExtraLoop::Storage::RemoteStore
  @@config = {}

  # 
  # Instanciates the relevant transport class for the selected datastore
  # 
  def self.get_transport(datastore, credentials=nil, options={})
    classname = datastore.to_s.camel_case
    ExtraLoop::Storage.const_get(classname).new(credentials, options) if ExtraLoop::Storage.const_defined?(classname)
  end

  def initialize(credentials, options={})
    datastore = self.class.to_s.snake_case.split('/').last.to_sym
    load_config
    @options = options
    @credentials = credentials || config_for([:datastore, datastore])
    raise ExtraLoop::Storage::Exceptions::MissingCredentialsError.new "Missing credentials for '#{datastore}' remote store"  unless @credentials
    @api = nil
  end

  protected
  def config_for(keys, context=@@config)
    key = keys.shift.to_s
    value = context.stringify_keys[key]
    value && value.respond_to?(:fetch) && keys.any? ? config_for(keys, value) : value
  end

  def load_config
    config_file = File.join(Etc.getpwuid.dir, '.extraloop.yml')
    @@config = File.exist?(config_file) && YAML::load_file(config_file) || {}
  end
end

module ExtraLoop::Storage::Exceptions
  class MissingCredentialsError < StandardError; end
end
