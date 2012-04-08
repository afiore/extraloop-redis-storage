# Public: Provides a convinient mechanism to override 
# Ohm's default id assignment mechanism and replace
# numeric, auto-increment ids with more readable, unique
# keys
#
module ExtraLoop::Storage::IdKey

  # Internal: A regex to be used in order to valid the key string format
  ID_FORMAT = /^[a-zA-Z\-\_]+$/ 
  # Internal: The separator to be used when record id keys.
  KEY_SEPARATOR = ':'

  # Public: Turns 'Ohm::Model::[]' into a powerful method which behaves somehow like Rails' "find_or_create"/"find_or_update".
  #
  # If the record does not exist, it will be created (or just initialised) with the provided attribute values. If the record does exist already, and
  # no attributes are provided, the record will be fetched and returned. If the record exists and the attribute hash is provided, this method will try 
  # to update it with the provided attribute values.
  #
  # TODO: consider privatising/removing the #save and the #create method for models extended with this module.
  #
  #
  # id - An alphanumeric id string, which will be used generate the key string to store the record into Redis.
  # attributes - An hash of record attributes.
  # 
  # 
  # Examples
  #
  # user = User['bob', {:full_name => 'Robert Plancton', :website => 'http://planktonic.net'}]
  # user.id 
  # 
  # => 'User:bob'
  #
  # User['bob'] == user
  #
  # => true
  #
  # user = User['bob', {:website => 'http://planctoinic.net' }]
  # user.website
  #
  # => 'http://planctoinic.net'
  #
  # 
  # Returns a Ohm record.
  # Raises an 'ArgumentError' if the provided id string does not match the ID_FORMAT (e.g. if it contains non-alphanumeric characters').
  #
  def [](id, attributes={})
    # automatically strip prefix from id
    id = id.to_s.gsub(prefix + KEY_SEPARATOR, '')
    raise ArgumentError.new "Invalid id '#{id}'" unless id =~ ID_FORMAT
    id = [prefix, id].reject(&:empty?).join(KEY_SEPARATOR)

    if record = super(id)
      record.update(attributes) if attributes.any?
      record
    else 
      create(attributes.merge(:id => id))
    end
  end

  # Public: Prefixes the provided record id with a namespace.
  #
  # While default behviour is to prepend the record's model class name to id string, it is possible to override this method
  # so that the generated record id key will include other attributes (see example below).
  #
  # attributes - The attributes hash
  #
  # Examples
  # 
  # # Overrides the default prefix method so that the 'locale' attribute will be included as part of the 
  # # record id prefix.
  #
  # include ExtraLoop::Storage
  #
  # class Entry < Record
  #   extend IdKey
  #   attribute :locale
  #
  #   def self::prefix(attrs={})
  #     [self.name, attrs.fetch(:locale, 'en')].join(IdKey::KEY_SEPARATOR)
  #   end
  # end
  #
  # entry = Entry['Hello-world']
  # entry.id
  #
  # => 'Entry:en:Hello-world'
  #
  # Returns the record id key.
  #

  def prefix(attributes={})
    self.name
  end

end
