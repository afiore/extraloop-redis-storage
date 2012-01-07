module ExtraLoop
  module Storage

    class Record < Ohm::Model
      include Ohm::Boundaries
      include Ohm::Timestamping


      reference :session, ExtraLoop::Storage::ScrapingSession
      attribute :extracted_at


      def self.create(attrs={})
        klass = self

        while klass != Record
          attributes.concat(klass.superclass.attributes)
          indices.concat(klass.superclass.indices)
          klass = klass.superclass
        end

        super(attrs)
      end


      def validate
        assert_present :session
      end
    end
  end
end
