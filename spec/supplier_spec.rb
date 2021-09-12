require "supplier"

describe Supplier do
  describe ".invoice" do
    it "returns an empty hash of line items for a nil order" do
      supplier = described_class.new
      expect(supplier.invoice([])).to be_empty
    end
  end
end
