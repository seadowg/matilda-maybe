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

  def or(*args, &block)
    if args.empty?
      block.call
    else
      args.first
    end
  end

  def get(*args, &block)
    if args.empty?
      block.call
    else
      args.first
    end
  end

  def ==(object)
    if object.class == Nothing
      true
    else
      false
    end
  end
end
