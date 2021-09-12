class Supplier
  def initialize(store = {})
    @store = store
  end

  def invoice(_customer_orders)
    {}
  end
end
