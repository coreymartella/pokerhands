require "spec_helper"
require "hand"
describe Hand, '#initialize' do
  it "can be initialized with random cards" do
    hand1 = Hand.new
    hand2 = Hand.new
    expect(hand1).to_not eq(hand2)
  end
  it "can be initialized with card objects" do
    expect{Hand.new(Card.new("9H"), "rand","rand","rand","rand")}.to_not raise_error
  end
  it "cannot be initialized with less than or more than 5 cards" do
    expect{Hand.new("9H")}.to raise_error(ArgumentError)
    expect{Hand.new("2H,3H,4H,5H,6H,7H")}.to raise_error(ArgumentError)
  end
end
describe Hand, '#category' do
  it "recognizes high_card" do
    expect(Hand.new("2H,4H,6H,8H,10D").category).to eq(:high_card)
  end
  it "recognizes one_pair" do
    expect(Hand.new("10H,10S,QH,KH,AH").category).to eq(:one_pair)
  end
  it "recognizes two_pair" do
    expect(Hand.new("10H,10S,QH,QS,AH").category).to eq(:two_pair)
  end
  it "recognizes three_of_a_kind" do
    expect(Hand.new("10H,10S,10C,KH,AH").category).to eq(:three_of_a_kind)
  end
  it "recognizes straight" do
    expect(Hand.new("10H,JH,QH,KH,9S").category).to eq(:straight)
  end
  it "recognizes flush" do
    expect(Hand.new("8H,JH,QH,KH,AH").category).to eq(:flush)
  end
  it "recognizes full_house" do
    expect(Hand.new("10H,10S,10C,KH,KS").category).to eq(:full_house)
  end
  it "recognizes fou" do
    expect(Hand.new("10H,10S,10C,10D,AH").category).to eq(:four_of_a_kind)
  end
  it "recognizes a high card hand" do
    expect(Hand.new("10H,JH,QH,KH,9H").category).to eq(:straight_flush)
  end
  it "recognizes a royal_flush" do
    expect(Hand.new("10H,JH,QH,KH,AH").category).to eq(:royal_flush)
  end
end
describe Hand, '#to_s' do
  it "represents the hand" do
    expect(Hand.new("2H,4H,6H,8H,10D").to_s).to eq("<high_card:2H,4H,6H,8H,10D>")
  end
end
describe Hand,'#winner' do
  it "declares a winner by category" do
    high_card = Hand.new("2H,4H,6H,8H,10D")
    pair = Hand.new("2C,2S,6S,8S,10S")
    expect(Hand.winner(high_card,pair)).to eq(:hand2)
    expect(Hand.winner(pair,high_card)).to eq(:hand1)
  end
  it "declares a draw" do
    high_card = Hand.new("2H,4H,6H,8H,10D")
    pair = Hand.new("2C,2S,6S,8S,10S")
    expect(Hand.winner(high_card,high_card)).to eq(:draw)
  end
  it "declares a winner by tiebreaker" do
    pairK = Hand.new("2H,4H,6H,KH,KD")
    pairA = Hand.new("2C,4S,6S,AH,AD")
    expect(Hand.winner(pairK,pairA)).to eq(:hand2)
  end
end
describe Hand, '>' do
  it "treats hands as greater than others" do
    high_card = Hand.new("2H,4H,6H,8H,10D")
    pair = Hand.new("2C,2S,6S,8S,10S")
    expect(pair > high_card).to eq(true)
  end
end
describe Hand, '>' do
  it "treats hands as less than others" do
    high_card = Hand.new("2H,4H,6H,8H,10D")
    pair = Hand.new("2C,2S,6S,8S,10S")
    expect(high_card < pair).to eq(true)
  end
end