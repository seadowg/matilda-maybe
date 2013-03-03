class Maybe
  def bind(&block)
    Maybe.new
  end
end

class Just < Maybe
  def method_missing(method_name, *args, &block)
    if Just.method_defined?(method_name)
      super
    else
      values = args.map { |arg|
        return Nothing.new if arg == Nothing.new
        arg.kind_of?(Just) ? arg.value : arg
      }
      Just.new(@value.public_send(method_name, *values, &block))
    end
  end

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
  def method_missing(method_name, *args, &block)
    if Nothing.method_defined?(method_name)
      super
    else
      Nothing.new
    end
  end
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
