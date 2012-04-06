# Meta model designed to keep track of what types of records
# are associated to a Scraping session object.
#
class ExtraLoop::Storage::Model < Ohm::Model
  extend ExtraLoop::Storage::IdKey


  # Internal: Overrides the default id key handling function and 
  # replaces it with a validity check
  #
  # Returns the model name
  # Raises an ArgumentError if the id string is not capitalized
  #

  def self.prefix(id)
    raise ArgumentError.new "model Id should be capitalized" unless id.to_s[0] =~ /[A-Z]/
    id
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
