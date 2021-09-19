require "invoice"

describe Invoice do
  it "generates an invoice for no item" do
    invoice = described_class.new
    expect(invoice.print_format).to eq <<~EO_INVOICE.chomp
      Fruit Invoice System
      -----------------------------
      Empty Order
      -----------------------------
      TOTAL                   $0.00
    EO_INVOICE
  end

  it "generates an invoice for 1 item" do
    invoice = described_class.new
    invoice.add_order({ product: "Watermelons", quantity: 3, total_price_in_cents: 699,
                        packs_order: {
                          "3 pack": { pack: 3, price_in_cents: 699, quantity: 1 },
                        }, })
    expect(invoice.print_format).to eq <<~EO_INVOICE.chomp
      Fruit Invoice System
      -----------------------------
      3 Watermelons           $6.99
        - 1 x 3 pack @ $6.99
      -----------------------------
      TOTAL                   $6.99
    EO_INVOICE
  end

  it "generates an invoice for many items" do
    invoice = described_class.new
    invoice.add_order({ product: "Watermelons", quantity: 15, total_price_in_cents: 2697,
                        packs_order: { "5 pack": { pack: 5, price_in_cents: 899, quantity: 3 } }, })
    invoice.add_order({ product: "Pineapples",
                        quantity: 14,
                        total_price_in_cents: 5380,
                        packs_order: { "5 pack": { pack: 5, price_in_cents: 1695, quantity: 2 },
                                       "2 pack": { pack: 2, price_in_cents: 995, quantity: 2 }, }, })
    invoice.add_order({ product: "Rockmelons",
                        quantity: 13,
                        total_price_in_cents: 2585,
                        packs_order: { "5 pack": { pack: 5, price_in_cents: 995, quantity: 2 },
                                       "3 pack": { pack: 3, price_in_cents: 595, quantity: 1 }, }, })
    expect(invoice.print_format).to eq <<~EO_INVOICE.chomp
      Fruit Invoice System
      -----------------------------
      15 Watermelons          $26.97
        - 3 x 5 pack @ $8.99
      14 Pineapples           $53.80
        - 2 x 5 pack @ $16.95
        - 2 x 2 pack @ $9.95
      13 Rockmelons           $25.85
        - 2 x 5 pack @ $9.95
        - 1 x 3 pack @ $5.95
      -----------------------------
      TOTAL                 $106.62
    EO_INVOICE
  end
end
