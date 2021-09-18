class Store
  MAX_VALUE = 100_000_000
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
    return 0 if quantity.zero?
    return MAX_VALUE if quantity.negative? || (items.empty? && quantity.positive?)
    return @cost_per_quantity[quantity] unless invalid_cost?(@cost_per_quantity[quantity])

    last_item = items.pop

    rejected = find_cost(items, quantity)
    selected = last_item[:price_in_cents] + find_cost(items.push(last_item), quantity - last_item[:count])

    @cost_per_quantity[quantity] = select_minimum_cost(last_item, selected, rejected)
  end

  def select_minimum_cost(last_item, selected, rejected)
    if selected < rejected
      @selected_pack_count.push(last_item[:count])
      selected
    else
      rejected
    end
  end

  def invalid_cost?(costs)
    [-1, MAX_VALUE].include?(costs)
  end

  def pack_init(pack_count, pack_cost)
    {
      pack: pack_count,
      price_in_cents: pack_cost,
      quantity: 0,
    }
  end

  def item_packs_cost(items, count)
    items.find { |x| x[:count] == count }[:price_in_cents]
  end

  def select_items(costs, quantity, items)
    selected_items = []
    total_quantity = quantity
    total_costs = 0
    @selected_pack_count.each do |item|
      total_quantity -= item
      selected_items.push(item)
      total_costs += item_packs_cost(items, item)
      if total_quantity.negative?
        total_quantity += item
        total_costs -= item_packs_cost(items, item)
        selected_items.pop
      elsif total_quantity.zero? && total_costs == costs
        break
      end
    end
    selected_items
  end

  def packs_based_on_cost(items, quantity, costs)
    selected_packs = {}
    selected_items = select_items(costs, quantity, items)

    selected_items.each do |item|
      items_key = "#{item} pack".to_sym
      selected_packs[items_key] = pack_init(item, item_packs_cost(items, item)) if selected_packs[items_key].nil?

      selected_packs[items_key][:quantity] += 1
    end
    selected_packs
  end

  def find_packs(product, items, quantity)
    @cost_per_quantity = Array.new(quantity + 1, -1)
    @selected_pack_count = []
    costs = find_cost(items.dup, quantity)

    if costs >= MAX_VALUE
      raise ArgumentError,
            "no product item to fulfill #{product.inspect}, #{quantity} precisely"
    end

    selected_packs = packs_based_on_cost(items.dup, quantity, costs)

    {
      packs: selected_packs,
      costs: costs,
    }
  end

  def find_product(line_item)
    raise ArgumentError, "no product #{line_item[:product].inspect}" unless @inventory.key?(line_item[:product])

    items = @inventory[line_item[:product]].sort_by { |item| item[:count] }.reverse
    find_packs(line_item[:product], items, line_item[:quantity])
  end
end
