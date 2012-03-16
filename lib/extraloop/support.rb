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
