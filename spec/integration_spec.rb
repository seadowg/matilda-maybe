require 'spec_helper'
require 'ruby-maybe'

describe "Integration Specs" do
  it "works as expected" do
    Just.new(5).bind { |val|
      Just.new(val * 3)
    }.bind { |val|
      if (val > 10)
        Nothing.new
      else
        Just.new(val) + 1
      end
    }.must_equal(Nothing.new)
  end
end
