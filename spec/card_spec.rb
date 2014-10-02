require "spec_helper"
require "card"
describe Card, '#initialize' do
  before(:each) do
    Deck.instance.reset
  end
  it "accepts a hash" do
    card = Card.new(rank: 9, suit: "H")
    expect(card.rank).to eq(9)
    expect(card.suit).to eq("H")
  end
  it "accepts a string" do
    card = Card.new("9H")
    expect(card.rank).to eq(9)
    expect(card.suit).to eq("H")
  end
  it "accepts \"rand\"" do
    card1 = Card.new("rand")
    card2 = Card.new("rand")
    expect(card1).to_not eq(card2)
  end
  it "does not accept invalid arguments" do
    expect{Card.new([])}.to raise_error(ArgumentError)
    expect{Card.new(0)}.to raise_error(ArgumentError)
    expect{Card.new("0H")}.to raise_error(ArgumentError)
    expect{Card.new("9Z")}.to raise_error(ArgumentError)
  end
end
