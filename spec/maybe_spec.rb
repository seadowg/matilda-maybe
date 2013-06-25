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
