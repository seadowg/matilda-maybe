class Maybe
  def self.from(value)
    if !value.nil?
      Just.new(value)
    else
      Nothing.new
    end
  end
end
