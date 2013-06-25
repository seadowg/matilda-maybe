require 'spec_helper'
require 'ruby-maybe'

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

  describe "#map" do
    it "returns Nothing" do
      Nothing.new.map { |val| val }.must_equal Nothing.new
    end
  end

  describe "#or" do
    it "evaluates arg, returning result" do
      (Nothing.new.or { Just.new(5) }).must_equal Just.new(5)
      Nothing.new.or(Just.new(5)).must_equal Just.new(5)
    end

    it "chain or calls, returning last value" do
      (Nothing.new.or { Nothing.new.or { Just.new(10) } }).must_equal Just.new(10)
    end
  end

  describe "#get" do
    it "evaluates arg, returning result" do
      (Nothing.new.get { 5 }).must_equal 5
      Nothing.new.get(5).must_equal 5
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
