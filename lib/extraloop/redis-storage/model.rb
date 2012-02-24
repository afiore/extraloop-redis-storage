# Meta model designed to keep track of what types of records
# are associated to a Scraping session object.
#
class ExtraLoop::Storage::Model < Ohm::Model
  attribute :name
  index :name
end
