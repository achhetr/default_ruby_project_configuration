class Store
  MAX_VALUE = 100_100_100
  def initialize(inventory)
    @inventory = inventory
  end

  def packs(line_item)
    packs_and_costs = find_product(line_item)
    line_item.merge(packs_order: packs_and_costs[:packs],
                    total_price_in_cents: packs_and_costs[:costs],)
  end

  private

  def find_cost(items, quantity)
    return MAX_VALUE if items.empty? && quantity.positive?

    return 0 if quantity.zero?

    last_item = items.pop

    if quantity < last_item[:count]
      find_cost(items, quantity)
    else
      rejected = find_cost(items, quantity)
      selected = last_item[:price_in_cents] + find_cost(items.push(last_item), quantity - last_item[:count])
      [rejected, selected].min
    end
  end

  def packs_based_on_cost(items, costs)
    selected_items = {}
    while costs.positive?
      last_item = items.pop

      next unless (costs - last_item[:price_in_cents]) >= 0

      items_key = "#{last_item[:count]} pack".to_sym

      if selected_items[items_key].nil?
        selected_items[items_key] = {
          pack: last_item[:count],
          price_in_cents: last_item[:price_in_cents],
          quantity: 0,
        }
      end

      selected_items[items_key][:quantity] += 1
      items.push(last_item)
      costs -= last_item[:price_in_cents]
    end
    selected_items
  end

  def find_packs(product, items, quantity)
    costs = find_cost(items.dup, quantity)

    if costs >= MAX_VALUE
      raise ArgumentError,
            "no product item to fulfill #{product.inspect}, #{quantity} precisely"
    end

    # find packs based on the total costs
    selected_packs = packs_based_on_cost(items.dup, costs)

    {
      packs: selected_packs,
      costs: costs,
    }
  end

  def find_product(line_item)
    raise ArgumentError, "no product #{line_item[:product].inspect}" unless @inventory.key?(line_item[:product])

    items = @inventory[line_item[:product]].sort_by { |item| item[:count] }
    find_packs(line_item[:product], items, line_item[:quantity])
  end
end
