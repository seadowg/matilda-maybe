class Nothing < Maybe
  def method_missing(method_name, *args, &block)
    Nothing.new
  end

  def bind
    Nothing.new
  end

  def map
    Nothing.new
  end

  def or(&block)
    block.call
  end

  def get(&block)
    block.call
  end

  def ==(object)
    if object.class == Nothing
      true
    else
      false
    end
  end
end
