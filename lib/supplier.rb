require "store"
require "order"
require "invoice"

class Supplier
  def initialize(inventory)
    @store = Store.new(inventory)
  end

  def invoice(customer_order_input)
    order = Order.new(customer_order_input)
    invoice = Invoice.new
    order.line_items.each do |line_item|
      invoice.add_order(@store.packs(line_item))
    end
    invoice.print_format
  end
end
