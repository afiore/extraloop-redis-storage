module ExtraLoop
  module Storage

    class ScrapingSession < Ohm::Model
      attribute :title

      def records(collection)
        Kernel.const_get(collection.to_s.capitalize).
          find(:session_id => self.id)
      end
    end
  end
end
