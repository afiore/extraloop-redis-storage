class ExtraLoop::Storage::Record < Ohm::Model
  include Ohm::Callbacks
  include Ohm::Boundaries
  include Ohm::Typecast
  include Ohm::Timestamping

  reference :session, ExtraLoop::Storage::ScrapingSession
  attribute :extracted_at, Time
  index :session_id

  def initialize attrs={}
    self.class.send :_inherit!
    super attrs
  end

  def self.create attrs={}
    _inherit!
    super attrs
  end

  def to_hash
    super.merge(attributes.reduce({}) { |memo, attribute| 
      memo.merge(attribute => send(attribute)) 
    })
  end

  def to_yaml
    to_hash.to_yaml
  end

  def validate
    assert_present :session
  end

  # 
  # walks up the class hierarchy and incorporate
  # Ohm attributes and indices from the superclasses
  #
  def self._inherit!
    klass = self

    while klass != ExtraLoop::Storage::Record
      %w[attributes indices counters].each do |method|
        send(method).concat(klass.superclass.send(method)).uniq!
      end
      klass = klass.superclass
    end
  end

  private_class_method :_inherit!
end
