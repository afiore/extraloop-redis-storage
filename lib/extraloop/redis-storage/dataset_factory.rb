module ExtraLoop
  module Storage

    # Creates a simple class to store an ExtraLoop 
    # generated data set using Ohm
  
    class DatasetFactory
      def initialize(classname, attributes=[])
        @classname = classname.to_s.capitalize

        Object.const_set(@classname, Class.new(Record) {
          attributes.each { |attr| attribute attr }
        })
      end

      def get_class
        Object.const_get(@classname)
      end
    end
  end
end
