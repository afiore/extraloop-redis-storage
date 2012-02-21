# Creates a simple class to store an ExtraLoop 
# generated dataset using Ohm

class ExtraLoop::Storage::DatasetFactory
  def initialize(classname, attributes=[])

    @classname = (classname.to_s.split "").each_with_index.map { |char, index| index == 0 && char.upcase or char }.join

    return if Object.const_defined? @classname
    Object.const_set(@classname, Class.new(ExtraLoop::Storage::Record) {
      attributes.each { |attr| attribute attr }
    })
  end

  def get_class
    Object.const_get(@classname)
  end
end
