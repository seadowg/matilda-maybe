class Maybe
  def bind(&block)
    Maybe.new
  end
end

class Just < Maybe
  def initialize(value)
    @value = value
  end
  
  def bind(&block)
    value = block.call(@value)
    warn("Not returning a Maybe from #bind is really bad form...") unless value.kind_of?(Maybe)
    value
  end
  
  def ==(object)
    if object.class == Just
      object.value == self.value
    else
      false
    end
  end
  
  protected
  
  def value
    @value
  end
end

class Nothing < Maybe
  def bind
    Nothing.new
  end
  
  def ==(object)
    if object.class == Nothing
      true
    else
      false
    end
  end
end