module ExtraLoop
  module Storage

    class Record < Ohm::Model
      include Ohm::Boundaries
      include Ohm::Timestamping


      reference :session, ExtraLoop::Storage::ScrapingSession
      attribute :extracted_at


      def self.create(attrs={})

        # walk up the class hierarchy and incorporate
        # superclass attributes 

        klass = self
        while klass != Record
          attributes.concat(klass.superclass.attributes).uniq!
          indices.concat(klass.superclass.indices).uniq!
          klass = klass.superclass
        end

        super(attrs)
      end

      def to_hash
        super.merge(attributes.reduce({}) { |memo, attribute| 
          memo.merge(attribute => send(attribute)) 
        })
      end




      def validate
        assert_present :session
      end
    end
  end
end
