require 'spec_helper'
require 'ruby-maybe'

describe "Integration Specs" do
  it "works as expected" do
    Just.new(5).bind { |val|
      Just.new(val).map { |val|
        val * 3
      }
    }.bind { |val|
      if (val > 10)
        Nothing.new
      else
        Just.new(val) + 1
      end
    }.must_equal(Nothing.new)
  end

  it "has the correct interface" do
    has_method(:bind)
    has_method(:map)
    has_method(:or)
    has_method(:get)
    has_method(:==)
  end
end

def has_method(name)
  assert(Just.method_defined?(name), "Just does not respond to #{name}")
  assert(Nothing.method_defined?(name), "Nothing does not respond to #{name}")
end
