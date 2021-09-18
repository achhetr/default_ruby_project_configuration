class Invoice
  def initialize
    @items = []
  end

  def add_order(order_line_item)
    @items << order_line_item
  end

  def print_format
    total_cents = 0
    output = [format_header]
    output << "-----------------------------"
    output << "Orders Empty\n" if @items.empty?

    @items.each do |item|
      output << format_item(item)
      total_cents += item[:total_price_in_cents]
      item[:packs_order].each do |pack, order|
        output << format_packs(pack, order)
      end
    end
    output << "-----------------------------"
    output << format("TOTAL %23s", in_dollars(total_cents))
    output.join("\n")
  end

  private

  def in_dollars(value_in_cents)
    format("$%0.2f", value_in_cents / 100.0)
  end

  def format_header
    "Fruit Invoice System\n\n"
  end

  def format_item(item)
    format(
      "%<count>d %-18<product>s %8<amount>s\n",
      count: item[:quantity], product: item[:product], amount: in_dollars(item[:total_price_in_cents]),
    )
  end

  def format_packs(pack, order)
    format(
      "  - %<pack_count>s x %<pack>s @ %<pack_price>s\n",
      pack_count: order[:quantity], pack: pack, pack_price: in_dollars(order[:price_in_cents]),
    )
  end
end
