require "invoice"

describe Invoice do
  it "generates an invoice for 1 item" do
    invoice = described_class.new
    invoice.add_order({ product: "Watermelons", quantity: 3, product_item: "3 pack", price_in_cents: 699 })
    expect(invoice.print_format).to eq <<~EO_INVOICE.chomp
      3 Watermelons           $6.99
        - 1 x 3 pack @ $6.99
      -----------------------------
      TOTAL                   $6.99
    EO_INVOICE
  end

  it "generates an invoice for many items" do
    invoice = described_class.new
    invoice.add_order({ product: "Watermelons", quantity: 3, product_item: "3 pack", price_in_cents: 699 })
    invoice.add_order({ product: "Pineapples", quantity: 8, product_item: "8 pack", price_in_cents: 2495 })
    invoice.add_order({ product: "Rockmelons", quantity: 3, product_item: "3 pack", price_in_cents: 595 })
    expect(invoice.print_format).to eq <<~EO_INVOICE.chomp
      3 Watermelons           $6.99
        - 1 x 3 pack @ $6.99
      8 Pineapples           $24.95
        - 1 x 8 pack @ $24.95
      3 Rockmelons            $5.95
        - 1 x 3 pack @ $5.95
      -----------------------------
      TOTAL                  $37.89
    EO_INVOICE
  end
end
