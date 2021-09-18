require "order"

describe Order do
  let(:customer_order_input) { "10 Watermelons\n14 Pineapples\n13 Rockmelons" }

  it "returns an empty list of line items for a nil order" do
    order = described_class.new
    expect(order.line_items).to be_empty
  end

  it "returns an empty list of line items for a blank order" do
    order = described_class.new("\n\n\t\n")
    expect(order.line_items).to be_empty
  end

  it "parses the order into line items" do
    order = described_class.new(customer_order_input)
    expect(order.line_items).to eq(
      [
        {
          product: "Watermelons",
          quantity: 10,
          total_price_in_cents: 0,
          packs_order: {},
        },
        {
          product: "Pineapples",
          quantity: 14,
          total_price_in_cents: 0,
          packs_order: {},
        },
        {
          product: "Rockmelons",
          quantity: 13,
          total_price_in_cents: 0,
          packs_order: {},
        },
      ],
    )
  end

  it "raises an exception if the quantity is not an integer" do
    order = described_class.new("10.1 is not an integer")
    expect do
      order.line_items
    end.to raise_error ArgumentError, "quantity needs to be an integer \"10.1\" for \"10.1 is not an integer\""
  end
end
