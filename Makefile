PROJECT := Fruits Invoicing System a beginning

test:
	bundle exec rspec

prettier:
	bundle exec rubocop -A

simple_demo:
	echo "5 Watermelons\n8 Pineapples\n3 Rockmelons" | bin/invoicing_system.rb

build: prettier test simple_demo