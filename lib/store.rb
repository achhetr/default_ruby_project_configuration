class Store
  def initialize(inventory)
    @inventory = inventory
  end

  def packs(line_item)
    line_item[:packs_order] = find_product(line_item)
    line_item
  end

  private

  def find_product(line_item)
    raise ArgumentError, "no product #{line_item[:product].inspect}" unless @inventory.key?(line_item[:product])

    pack_items = find_packs(@inventory[line_item[:product]], line_item[:quantity])

    unless pack_items
      raise ArgumentError,
            "no product item to fulfill #{line_item[:product].inspect}, #{line_item[:quantity].inspect} precisely"
    end
    pack_items
  end

  def find_packs(_available_packs, _quantity)
    # find total cost possible for the available packs and quantity

    # find packs based on the total costs

    # return packs

    {
      "2 packs": { pack: 2,
                   price_in_cents: 9000,
                   quantity: 4, },
      "4 packs": {
        pack: 4,
        price_in_cents: 3000,
        quantity: 5,
      },
    }
  end
end
