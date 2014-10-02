require 'simplecov'
SimpleCov.start unless $simple_cov_started
$simple_cov_started = true
RSpec.configure do |c|
  c.before(:each) {Deck.instance.reset}
end