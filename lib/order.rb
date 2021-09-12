class Order
  def initialize(customer_order_input = "")
    @customer_order_input = customer_order_input&.split("\n")&.map(&:strip) || []
  end

  def line_items
    @customer_order_input.reject(&:empty?).map do |line|
      quantity, product = line.split
      unless quantity.to_i.to_s == quantity
        raise ArgumentError,
              "quantity needs to be an integer #{quantity.inspect} for #{line.inspect}"
      end

      {
        product: product,
        quantity: Integer(quantity),
      }
    end
  end
end
