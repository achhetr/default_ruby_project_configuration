require "supplier"

describe Supplier do
  let(:inventory) do
    {
      "Watermelons" => [
        { count: 3, price_in_cents: 699 },
        { count: 5, price_in_cents: 899 },
      ],
      "Pineapples" => [
        { count: 2, price_in_cents: 995 },
        { count: 5, price_in_cents: 1695 },
        { count: 8, price_in_cents: 2495 },
      ],
      "Rockmelons" => [
        { count: 3, price_in_cents: 595 },
        { count: 5, price_in_cents: 995 },
        { count: 9, price_in_cents: 1699 },
      ],
    }
  end

  it "generates the expected invoice with simple input" do
    customer_order_input = "5 Watermelons\n8 Pineapples\n3 Rockmelons"
    invoicing_app = described_class.new(inventory)

    expect(invoicing_app.invoice(customer_order_input)).to eq <<~EO_INVOICE.chomp
      Fruit Invoice System
      -----------------------------
      5 Watermelons           $8.99
        - 1 x 5 pack @ $8.99
      8 Pineapples           $24.95
        - 1 x 8 pack @ $24.95
      3 Rockmelons            $5.95
        - 1 x 3 pack @ $5.95
      -----------------------------
      TOTAL                  $39.89
    EO_INVOICE
  end

  it "generates the expected invoice with complex input" do
    customer_order_input = "15 Watermelons\n14 Pineapples\n13 Rockmelons"
    invoicing_app = described_class.new(inventory)

    expect(invoicing_app.invoice(customer_order_input)).to eq <<~EO_INVOICE.chomp
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
