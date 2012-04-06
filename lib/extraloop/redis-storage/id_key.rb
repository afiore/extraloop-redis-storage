# Public: Provides a convinient mechanism to override 
# Ohm's default id assignment mechanism and replace
# numeric, auto-increment ids with more readable, unique
# keys
#
module ExtraLoop::Storage::IdKey
  # Public: A regex to be used in order to valid the key string format
  ID_FORMAT = /^[a-zA-Z\-\_]+/ 

  def [](id, attributes={})
    id = prefix(id)
    raise ArgumentError.new "Invalid id '#{id}'" unless id =~ ID_FORMAT

    if record = super(id)
      record.update(attributes) if attributes.any?
      record
    else 
      create(attributes.merge(:id => id, :name => name))
    end
  end

  def prefix(id)
    [self.name, id].join(':')
  end

end
