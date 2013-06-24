require 'spec_helper'
require 'ruby-maybe'

describe "Maybe" do
  describe "#from" do
    it "returns Nothing if passed nil" do
      Maybe.from(nil).must_equal Nothing.new
    end
  end
end


describe "Just" do
  describe "#bind" do
    it "applys the passed block to its boxed value" do
      Just.new(5).bind { |val| Just.new(val * 2) }.must_equal Just.new(10)
    end
  end

  describe "#mplus" do
    it "ignores arg and returns self" do
      (Maybe.from(5).mplus{Maybe.from(10)}).must_equal Just.new(5)
    end
  end

  describe "#or_else" do
    it "ignores arg and returns self" do
      (Maybe.from(5).or_else{Maybe.from(10)}).must_equal Just.new(5)
    end
  end

  describe "#get_or_else" do
    it "ignores arg and returns value" do
      (Maybe.from(5).get_or_else{10}).must_equal 5
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

  describe "#_extract!" do
    it "returns the contained value" do
      Just.new(5)._extract!.must_equal(5)
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

  describe "#mplus" do
    it "evaluates arg, returning result" do
      (Nothing.new.mplus{Maybe.from(5)}).must_equal Just.new(5)
    end

    it "chain mplus calls, returning last value" do
      (Nothing.new.mplus{Nothing.new.mplus{Just.new(10)}}).must_equal Just.new(10)
    end
  end

  describe "#or_else" do
    it "evaluates arg, returning result" do
      (Nothing.new.or_else{Maybe.from(5)}).must_equal Just.new(5)
    end

    it "chain or_else calls, returning last value" do
      (Nothing.new.or_else{Nothing.new.or_else{Just.new(10)}}).must_equal Just.new(10)
    end
  end

  describe "#get_or_else" do
    it "evaluates arg, returning result" do
      (Nothing.new.get_or_else{5}).must_equal 5
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

  describe "#_extract!" do
    it "raises an exception" do
      assert_raises(Nothing::AttemptedExtract) {
        Nothing.new._extract!
      }
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
