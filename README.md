# EA Code Challenge: pokerhands

Ruby code representing recognition and comparison of [Poker Hands](http://en.wikipedia.org/wiki/List_of_poker_hands)

## External Dependencies:

* Ruby 1.9 or higher
* [RSpec 3](http://rspec.info/) for testing
* [SimpleCov](https://github.com/colszowka/simplecov) for code coverage

## Setup

To setup the dependencies run:

`bundle`

You'll need ruby setup with bundler (`gem install bundler` if you don't have it)

## Testing

To run the tests:

`bundle exec rspec`

RSpec will produce code coverage output at `coverage/index.html`

## Standalone

There is a standalone executable script to try out the code under `bin/poker.rb` to run it:

`ruby bin/poker.rb --help`

The code currently enforces that hands contain unique cards (5 card draw style), `deck.rb` could be easily adapted to not enforce uniqueness across hands by altering Deck#deal_card to not remove from the deck.

