class ExtraLoop::Storage::ScrapingSession < Ohm::Model

  include Ohm::Boundaries
  include Ohm::Timestamping
  include Ohm::Callbacks

  attribute :title
  reference :model, ExtraLoop::Storage::Model

  def records(params={})
    klass = Object.const_defined?(model.name) ?
      Object.const_get(model.name) :
      Object.const_set(model.name, Class.new(ExtraLoop::Storage::Record))

    klass.index :session_id if klass.indices.empty?

    klass.find({
      :session_id => self.id
    }.merge(params))
  end

  def validate
    assert_present :model
  end

  def to_json
  end

  def to_csv
  end
end
