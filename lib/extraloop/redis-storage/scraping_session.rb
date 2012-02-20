class ExtraLoop::Storage::ScrapingSession < Ohm::Model

  include Ohm::Boundaries
  include Ohm::Timestamping

  attribute :title

  def records(collection)
    Kernel.const_get(collection.to_s).
      find(:session_id => self.id)
  end
end
