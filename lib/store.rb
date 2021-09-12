class Store
  def initialize(inventory)
    @inventory = inventory
  end

  def pack(line_item)
    pack_item = find_product(line_item)

    line_item.merge(
      price_in_cents: pack_item[:price_in_cents],
      product_item: "#{pack_item[:count]} pack",
    )
  end

  private

  def find_product(line_item)
    raise ArgumentError, "no product #{line_item[:product].inspect}" unless @inventory.key?(line_item[:product])

    pack_item = @inventory[line_item[:product]].find { |item| item[:count] == line_item[:quantity] }

    unless pack_item
      raise ArgumentError,
            "no product item to fulfill #{line_item[:product].inspect}, #{line_item[:quantity].inspect} precisely"
    end
    pack_item
  end
end
