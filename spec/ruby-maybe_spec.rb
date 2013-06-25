require 'spec_helper'
require 'ruby-maybe'

describe "Maybe" do
  describe "#from" do
    it "returns Nothing if passed nil" do
      Maybe.from(nil).must_equal Nothing.new
    end

    it "returns Just if passed non-nil value" do
      Maybe.from(false).must_equal Just.new(false)
      Maybe.from(11).must_equal Just.new(11)
    end
  end
end


describe "Just" do
  describe "#bind" do
    it "applys the passed block to its boxed value" do
      Just.new(5).bind { |val| Just.new(val * 2) }.must_equal Just.new(10)
    end
  end

  describe "#or" do
    it "ignores arg and returns self" do
      (Just.new(5).or { 0 }).must_equal Just.new(5)
    end
  end

  describe "#get" do
    it "ignores arg and returns value" do
      (Just.new(5).get { 0 }).must_equal 5
    end
  end

  describe "#==" do
    it "returns false if the passed object is not a Just" do
      (Just.new(5) == 5).must_equal false
    end

    it "returns true if the passed object is a Just with the same value" do
      (Just.new(5) == Just.new(5)).must_equal true
    end
  end

  describe "method lifting" do
    it "allows using a method for the contained type" do
      just = Just.new(5)
      just.+(5).must_equal(Just.new(10))
    end

    it "allows passed arguments to be Maybe instances" do
      just = Just.new(5)
      just.+(Just.new(5)).must_equal(Just.new(10))
    end

    it "returns Nothing if any argument is Nothing" do
      just = Just.new("Hello")
      just.slice(Just.new(0), Nothing.new).must_equal(Nothing.new)
    end

    it "passes blocks correctly" do
      count = 0
      just = Just.new(5)
      just.times { |i| count += i }
      count.must_equal(10)
    end
  end
end

describe "Nothing" do
  describe "#bind" do
    it "does not execute the passed block" do
      executed = false
      Nothing.new.bind { |val| executed = true }
      executed.must_equal false
    end

    it "returns a Nothing" do
      Nothing.new.bind { |val| val }.kind_of?(Nothing).must_equal true
    end
  end

  describe "#or" do
    it "evaluates arg, returning result" do
      (Nothing.new.or { Just.new(5) }).must_equal Just.new(5)
    end

    it "chain or calls, returning last value" do
      (Nothing.new.or { Nothing.new.or { Just.new(10) } }).must_equal Just.new(10)
    end
  end

  describe "#get" do
    it "evaluates arg, returning result" do
      (Nothing.new.get { 5 }).must_equal 5
    end
  end

  describe "#==" do
    it "returns false if the passed object is not a Nothing" do
      (Nothing.new == 5).must_equal false
    end

    it "returns true if the passed object is a Nothing" do
      (Nothing.new == Nothing.new).must_equal true
    end
  end

  describe "method lifting" do
    it "returns Nothing for any method call" do
      Nothing.new.missing.must_equal(Nothing.new)
    end
  end
end

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
