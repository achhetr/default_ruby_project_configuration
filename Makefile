PROJECT := Fruits Invoicing System a beginning

test:
	bundle exec rspec

prettier:
	bundle exec rubocop -A

simple_demo:
	echo "" | bin/invoicing_system.rb

build: prettier test simple_demo