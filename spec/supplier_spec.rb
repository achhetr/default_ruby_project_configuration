require "supplier"

describe Supplier do
  describe ".invoice" do
    it "returns an empty hash of line items for a nil order" do
      order = described_class.new
      expect(order.invoice([])).to be_empty
    end
  end
end
