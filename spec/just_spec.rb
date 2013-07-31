require 'spec_helper'
require 'matilda-maybe'

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
    it "ignores the arguments and returns the value" do
      (Just.new(5).get { 0 }).must_equal 5
      Just.new(5).get(0).must_equal 5
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
