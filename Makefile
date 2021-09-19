PROJECT := Fruits Invoicing System a beginning

test:
	bundle exec rspec

prettier:
	bundle exec rubocop -A

simple_demo:
	echo "5 Watermelons\n8 Pineapples\n3 Rockmelons" | bin/invoicing_system.rb

complex_demo:
	echo "15 Watermelons\n14 Pineapples\n13 Rockmelons" | bin/invoicing_system.rb

build: prettier test simple_demo complex_demo