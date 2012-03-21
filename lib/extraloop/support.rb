class Hash
  def stringify_keys
    _reduce_keys &:to_s
  end

  def symbolize_keys
    _reduce_keys &:to_sym
  end

  private
  def _reduce_keys(&block)
    self.reduce({}){|memo,(k,v)| memo[yield(k)] = v; memo}
  end
end

class Object
  def try(method, *args)
    send method, *args if respond_to? method
  end
end

class String
  def camel_case
    self.gsub(/^.|_./) { |chars| chars.split("").last.upcase }
  end

  def snake_case
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end
