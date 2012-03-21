

class ExtraLoop::Storage::FusionTables < ExtraLoop::Storage::RemoteStore
  @@connection = nil

  def push(session)
    @api = connect!
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
      'id' => 'number',
      'session_id' => 'number'
    }

    option_schema = @options.fetch(:schema, {}).stringify_keys
    schema = defaults.merge option_schema
    record.keys.
      reject { |key| schema.keys.include?(key.to_s) }.
      map    { |key| {:name => key.to_s, :type => 'string'} }.
      concat(schema.map { |field, type| {:name => field.to_s, :type => type }})
  end

  def connect!
    return @@connection if @@connection
    @@connection = GData::Client::FusionTables.new
    @credentials = @credentials.symbolize_keys
    @@connection.clientlogin(@credentials[:username], @credentials[:password])
    @@connection
  end
end
