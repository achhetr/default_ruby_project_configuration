#!/usr/bin/env ruby

$LOAD_PATH << File.join(__dir__, "..", "lib")

require "supplier"
require "yaml"

customer_order_input = []
loop do
  input_line = gets
  break if input_line.nil?

  customer_order_input << input_line.chomp
end

supplier = Supplier.new(YAML.load_file(File.join(__dir__, "..", "price_config.yml")))
puts supplier.invoice(customer_order_input.join("\n"))
