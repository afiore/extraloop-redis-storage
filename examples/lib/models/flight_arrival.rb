Geocoder::Configuration.cache = Redis.new
Geocoder::Configuration.lookup = :yahoo
Geocoder::Configuration.always_raise << Geocoder::OverQueryLimitError
binding.pry

class FlightArrival < ExtraLoop::Storage::Record
  attribute :path
  attribute :scheduled_time
  attribute :status
  attribute :flight_number
  attribute :origin
  attribute :terminal

  before :save, :geojson_path!

  def geojson_path!
    heathrow_lng_lat = [-0.461389, 51.4775]
    max_attempts = 3

    multi_line = []

    origin.each do |_origin|
      attempts = 1
      begin
        multi_line << [ Geocoder.coordinates(_origin).try(:reverse), heathrow_lng_lat ]
      rescue Geocoder::OverQueryLimitError
        puts "attempt number #{attempt}"
        attempts += 1
        sleep attempts
        retry
      end
    end

    # use only the first airport name as the value of the origin column
    self.origin = origin.first if origin

    if multi_line.any? and multi_line.flatten.all?
      self.path = {
        :type => "MultiLineString",
        :coordinates => multi_line
      }.to_json
    end
  end
end
