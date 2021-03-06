class ExtraLoop::Storage::ScrapingSession < Ohm::Model

  include Ohm::Boundaries
  include Ohm::Timestamping
  include Ohm::Callbacks

  attribute :title
  reference :model, ExtraLoop::Storage::Model
  index :model_id
  
  def records(params={})
    klass = if Object.const_defined?(model.id)
      Object.const_get(model.id)
    else
      dynamic_class = Class.new(ExtraLoop::Storage::Record) do
        # override the default to_hash so that it will return the Redis hash
        # internally stored by Ohm
        def to_hash
          Ohm.redis.hgetall self.key
        end
      end

      Object.const_set(model.id, dynamic_class)
      dynamic_class
    end

    # set a session index, so that Ohm finder will work
    klass.indices << :session_id unless klass.indices.include? :session_id

    klass.find({
      :session_id => self.id
    }.merge(params))
  end

  def validate
    assert_present :model
  end

  def to_hash
    attrs = attributes.reduce({}) { |memo, attribute| 
      memo.merge(attribute => send(attribute))
    }.merge({
      :records => records.map(&:to_hash),
      :model => model.to_hash
    })

    super.merge attrs
  end

  def to_csv
    _records = Array records.all.map &:to_hash
    header = _records.first && _records.first.keys.map(&:to_s)
    data = [header].concat _records.map(&:values)
    output = data.map { |cells| CSV.generate_line cells }.join
  end

  def to_yaml
    to_hash.to_yaml
  end
end
