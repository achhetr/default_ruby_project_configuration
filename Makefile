PROJECT := Fruits Invoicing System a beginning

test:
	bundle exec rspec

prettier:
	bundle exec rubocop -A

build: prettier test

