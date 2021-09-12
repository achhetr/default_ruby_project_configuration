class Invoice
  def initialize
    @items = []
  end

  def add_order(order_line_item)
    @items << order_line_item
  end

  def print_format
    total_cents = 0
    output = []
    @items.map do |item|
      output << format_item(item)
      total_cents += item[:price_in_cents]
    end
    output << "-----------------------------"
    output << format("TOTAL %23s", in_dollars(total_cents))
    output.join("\n")
  end

  private

  def in_dollars(value_in_cents)
    format("$%0.2f", value_in_cents / 100.0)
  end

  def format_item(item)
    [
      format(
        "%<count>d %-18<product>s %8<amount>s",
        count: item[:quantity], product: item[:product], amount: in_dollars(item[:price_in_cents]),
      ),
      format(
        "  - %<pack_count>s x %<pack>s @ %<pack_price>s",
        pack_count: 1, pack: item[:product_item], pack_price: in_dollars(item[:price_in_cents]),
      ),
    ].join("\n")
  end
end
