class Just < Maybe
  def method_missing(method_name, *args, &block)
    values = args.map { |arg|
      return Nothing.new if arg == Nothing.new
      arg.kind_of?(Just) ? arg.value : arg
    }

    Just.new(@value.public_send(method_name, *values, &block))
  end

  def initialize(value)
    @value = value
  end

  def bind(&block)
    computed = block.call(@value)
    warn("Not returning a Maybe from #bind is really bad form...") unless computed.kind_of?(Maybe)
    computed
  end

  def map(&block)
    Just.new(block.call(@value))
  end

  def or(&block)
    self
  end

  def get(&block)
    @value
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
