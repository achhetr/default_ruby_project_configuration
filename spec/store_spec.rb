require "store"

describe Store do
  let(:inventory) do
    {
      "Watermelons" => [
        { count: 3, price_in_cents: 699 },
        { count: 5, price_in_cents: 899 },
      ],
      Pineapples: [
        { count: 2, price_in_cents: 995 },
        { count: 5, price_in_cents: 1695 },
        { count: 8, price_in_cents: 2495 },
      ],
      Rockmelons: [
        { count: 3, price_in_cents: 595 },
        { count: 5, price_in_cents: 995 },
        { count: 9, price_in_cents: 1699 },
      ],
    }
  end

  it "can pack 3 watermelons" do
    store = described_class.new(inventory)
    expect(
      store.pack(product: "Watermelons", quantity: 3),
    ).to eq({ product: "Watermelons", quantity: 3, product_item: "3 pack", price_in_cents: 699 })
  end

  it "can pack 5 watermelons" do
    store = described_class.new(inventory)
    expect(
      store.pack(product: "Watermelons", quantity: 5),
    ).to eq({ product: "Watermelons", quantity: 5, product_item: "5 pack", price_in_cents: 899 })
  end

  it "raises an error if the quanity cannot be fulfilled exactly" do
    store = described_class.new(inventory)
    expect do
      store.pack(product: "Watermelons", quantity: 4)
    end.to raise_error(ArgumentError, "no product item to fulfill \"Watermelons\", 4 precisely")
  end

  it "raises an error if trying to pack items it does not have like Zucchinis" do
    store = described_class.new(inventory)
    expect do
      store.pack(product: "Zucchinis", quantity: 5)
    end.to raise_error(ArgumentError, "no product \"Zucchinis\"")
  end
end
