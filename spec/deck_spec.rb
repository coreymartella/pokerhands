require "spec_helper"
require "deck"
describe Deck do
  describe '#shuffle' do
    it "can be reset" do
      old = Deck.instance.cards.dup
      expect(Deck.instance.reset).to_not eq(old)
    end
  end
  it "Can deal the top card" do
    top_card = Deck.instance.peek
    dealt_card = Deck.instance.deal
    expect(dealt_card).to eq(top_card)
  end
  it "Can deal a random card" do
    expect{Deck.instance.deal}.to change{Deck.instance.size}.by(-1)
  end
  it "Can deal a specific card" do
    card = "9H"
    expect{Deck.instance.deal_card(card)}.to change{Deck.instance.size}.by(-1)
  end
  it "Cannot deal a specific card twice" do
    card = "9H"
    expect{Deck.instance.deal_card(card)}.to change{Deck.instance.size}.by(-1)
    expect{Deck.instance.deal_card(card)}.to raise_error(ArgumentError)
  end
end
