class Card
  attr_reader :rank, :suit
  RANKS = (2..10).to_a + ["J","Q","K","A"]
  SUITS = ["D","H","S","C"]

  def initialize(*args)
    if args.empty? || args.first == 'rand'
      #get a random card still in the deck
      args = [Deck.instance.peek]
    end
    if args.size == 1 && args.first.is_a?(Hash)
      self.rank = args.first[:rank].to_s
      self.suit = args.first[:suit].to_s.upcase
    elsif args.size == 1 && args.first.is_a?(String)
      #handle "9H" as input
      self.rank = args.first[0..args.first.size-2] #rank is the first n-1 chars (handle 10)
      self.suit = args.first[-1..-1].upcase #suit is always the last char
    else
      raise ArgumentError, "#{args.inspect}, must be either string of rank and suit (\"9H\") or hash ({rank: 9, suit: \"H\"})"
    end
    validate
    Deck.instance.deal_card(self)
  end
  def to_s
    "#{rank}#{suit}"
  end
  def <=>(other)
    return -1 unless other.is_a?(Card)
    #sort by rank
    return rank_index < other.rank_index ? -1 : 1 if rank != other.rank
    #then by suit
    return SUITS.index(suit) - SUITS.index(other.suit)
  end
  def ==(other)
    return false unless other.is_a?(Card)
    other.rank == rank && other.suit == suit
  end
  def eql?(other)
    self == other
  end
  def hash
    to_s.hash
  end
  def rank_index
    RANKS.index(rank)
  end
  protected
    def rank=val
      #if the rank is a numeric string then use the integer val
      @rank = val.to_s =~ /\d+/ ? val.to_i : val
      validate && rank
    end
    def suit=val
      @suit = val.to_s.upcase
      validate && suit
    end
    def validate
      if rank && !RANKS.include?(rank)
        raise ArgumentError, "rank #{rank} must one of be: #{RANKS.join(",")}"
      end
      if suit && !SUITS.include?(suit)
        raise ArgumentError, "Invalid suit #{suit} must one of be: #{SUITS.join(",")}"
      end
      true
    end
end