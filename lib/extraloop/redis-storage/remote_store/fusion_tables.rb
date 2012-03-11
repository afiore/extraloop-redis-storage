class ExtraLoop::Storage::FusionTables
  @@connection = nil

  def initialize(credentials, options={})
    @options = options
    @credentials = credentials
    @api = connect
  end

  def push(session)
    dataset = session.to_hash
    records = dataset[:records]
    title   = dataset[:title].gsub(/\sDataset/,'')
    schema = make_schema(records.first)

    table = @api.create_table("Dataset #{title}", schema)
    table.insert records
  end

  private
  def make_schema(record)
    defaults = {
      'session_id' => 'number'
    }

    schema = defaults.merge(@options.fetch :schema, {})

    record.keys.
      reject { |key| schema.keys.include?(key) }.
      map    { |key| {:name => key.to_s, :type => 'string'} }.
      concat(schema.map { |field, type| {:name => field.to_s, :type => type }})
  end

  def connect
    return @@connection if @@connection

    @@connection = GData::Client::FusionTables.new
    @@connection.clientlogin(*@credentials)
    @@connection
  end
end
