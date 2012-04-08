# Meta model designed to keep track of what types of records
# are associated to a Scraping session object.
#
class ExtraLoop::Storage::Model < Ohm::Model
  extend ExtraLoop::Storage::IdKey

  class << self
    alias_method :'_[]', :[]

    def [](id, attributes={})
      id = id.to_s.gsub(prefix, '')
      raise ArgumentError.new "model name must be a constant" unless ('A'..'Z').include?(id[0])
      send('_[]', id, attributes)
    end

    def prefix
      ""
    end
  end

  def to_hash
    super.merge(attributes.reduce({}) { |memo, attribute| 
      memo.merge(attribute => send(attribute)) 
    })
  end
  def to_yaml
    to_hash.to_yaml
  end
end
