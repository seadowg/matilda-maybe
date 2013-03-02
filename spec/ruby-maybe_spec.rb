require 'minitest/autorun'
require 'ruby-maybe'

describe "Just" do
  describe "#bind" do
    it "applys the passed block to its boxed value" do
      Just.new(5).bind { |val| Just.new(val * 2) }.must_equal Just.new(10)
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

  describe "#==" do
    it "returns false if the passed object is not a Just" do
      (Just.new(5) == 5).must_equal false
    end

    it "returns true if the passed object is a Just with the same value" do
      (Just.new(5) == Just.new(5)).must_equal true
    end
  end
end

describe "Maybe" do
  describe "#bind" do
    it "does not execute the passed block" do
      executed = false
      Maybe.new.bind { |val| executed = true }
      executed.must_equal false
    end

    it "returns a Maybe" do
      Maybe.new.bind { |val| val }.kind_of?(Maybe).must_equal true
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
end

describe "Integration Specs" do
  it "works as expected" do
    Just.new(5).bind { |val|
      Just.new(val * 3)
    }.bind { |val|
      if (val > 10)
        Nothing.new
      else
        Just.new(val)
      end
    }.must_equal(Nothing.new)
  end
end
