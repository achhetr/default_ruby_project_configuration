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
    expect(store.packs(product: "Watermelons",
                       quantity: 3,)).to eq({ product: "Watermelons", quantity: 3, total_price_in_cents: 699,
                                              packs_order:
                                                { "3 pack": { pack: 3, price_in_cents: 699, quantity: 1 } }, })
  end

  it "can pack 5 watermelons" do
    store = described_class.new(inventory)
    expect(store.packs(product: "Watermelons",
                       quantity: 5,)).to eq({ product: "Watermelons", quantity: 5, total_price_in_cents: 899,
                                              packs_order:
                                                { "5 pack": { pack: 5, price_in_cents: 899, quantity: 1 } }, })
  end

  it "raises an error if the quanity cannot be fulfilled exactly" do
    store = described_class.new(inventory)
    expect do
      store.packs(product: "Watermelons", quantity: 4)
    end.to raise_error(ArgumentError, "no product item to fulfill \"Watermelons\", 4 precisely")
  end

  it "raises an error if trying to pack items skip does not have like Zucchinis" do
    store = described_class.new(inventory)
    expect do
      store.packs(product: "Zucchinis", quantity: 5)
    end.to raise_error(ArgumentError, "no product \"Zucchinis\"")
  end
end
