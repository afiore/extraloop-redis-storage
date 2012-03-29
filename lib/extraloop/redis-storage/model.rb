# Meta model designed to keep track of what types of records
# are associated to a Scraping session object.
#
class ExtraLoop::Storage::Model < Ohm::Model

  def self.[](id)
    raise ArgumentError.new "model Id should be capitalized" unless id.to_s[0] =~ /[A-Z]/
    super(id) || create(:id => id)
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
