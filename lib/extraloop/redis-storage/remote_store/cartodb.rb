class ExtraLoop::Storage::Cartodb < ExtraLoop::Storage::RemoteStore
  @@connection = nil

  def connect!
    @@connection ||= CartoDB::Init.start @credentials.stringify_keys
  end

  def push(session)
     @api = connect!

     dataset = session.to_hash
     records = dataset[:records]
     title   = dataset[:title].gsub(/\sDataset/,'')
     schema = make_schema(records.first)
     data = {:type => 'FeatureCollection', :features => feature_collection = [] }

     records.each do |record|
       geom = JSON.parse(record['path'])
       
       if geom['coordinates'].first

         feature_collection << {
           :type => 'Feature',
           :properties => record.select { |k,| %w[origin].include? k},
           :geometry => geom
         }
       end
     end


     tempfile = File.join("/tmp", title.gsub(/\s/,"_") + '.json')
     File.open(tempfile, 'w') { |f| f.write data.to_json }

     table = @api.create_table "#{title}", File.open(tempfile, 'r')
     FileUtils.rm tempfile
     pp table
  end

  def make_schema(record)
    defaults = {
      'extracted_at' => 'date',
      'id' => 'numeric',
      'session_id' => 'numeric'
    }

    option_schema = @options.fetch(:schema, {}).stringify_keys
    schema = defaults.merge option_schema
    record.keys.
      reject { |key| schema.keys.include?(key.to_s) || %w[created_at updated_at extracted_at].include?(key.to_s) }.
      map    { |key| {:name => key.to_s, :type => 'text'} }.
      concat(schema.map { |field, type| {:name => field.to_s, :type => type }})
  end
end
