require './lib/card.rb'
require './lib/deck.rb'
class Hand
  CATEGORIES = [:high_card, :one_pair, :two_pair, :three_of_a_kind, :straight, :flush, :full_house, :four_of_a_kind, :straight_flush, :royal_flush]
  attr_reader :cards, :tiebreak_ranks
  def self.winner(hand1,hand2)
    if hand1 == hand2
      :draw
    else
      hand1 < hand2 ? :hand2 : :hand1
    end

  end
  def initialize(*args)
    if args.compact.size == 0
      args = ["rand,rand,rand,rand,rand"]
    end
    if args.size == 1 && args.first.is_a?(String)
      #override the args to be each card
      args = args.first.split(",")
    end
    if args.size != 5
      raise ArgumentError, "A hand must consist of 5 cards, you provided #{args.size}: #{args.inspect}"
    end
    @cards = []
    args.each do |arg|
      if arg.is_a?(String) || arg.is_a?(Hash)
        @cards << Card.new(arg)
      elsif arg.is_a?(Card)
        @cards << arg
      end
    end
    @cards = @cards.uniq.sort
    validate
  end
  def to_s
    "<#{category}:#{cards.map(&:to_s).join(",")}>"
  end
  def category
    @category ||= detect_category
  end
  def category_index
    CATEGORIES.index(category)
  end
  def ranks
    @ranks ||= @cards.map(&:rank)
  end
  def uniq_ranks
    ranks.uniq
  end
  def suits
    @suits ||= @cards.map(&:suit)
  end
  def suit_count
    suits.uniq.size
  end
  def low_rank
    @low_rank ||= @cards.first.rank
  end
  def low_rank_index
    Card::RANKS.index(low_rank)
  end
  def low_rank_index_with_ace
    #special scenario to handle Ace being the low rank in a straight
    @cards.last.rank == "A" ? -1 : Card::RANKS.index(@cards.first.rank)
  end
  def high_rank
    @cards.last.rank
  end
  def high_rank_index
    Card::RANKS.index(high_rank)
  end
  def rank_histogram
    @rank_histogram ||= @cards.reduce(Hash.new(0)){|h,c| h[c.rank] += 1; h}
  end
  def rank_counts
    @rank_counts ||= rank_histogram.values.sort
  end
  def <(other)
    (self <=> other) == -1
  end
  def >(other)
    (self <=> other) == 1
  end
  def <=>(other)
    return -1 unless other.is_a?(Hand)

    #use category to rank if they differ
    return category_index <=> other.category_index if category_index != other.category_index
      
    #then by tiebreaker
    tiebreak_ranks.zip(other.tiebreak_ranks).map do |r1,r2|
      r1i = Card::RANKS.index(r1)
      r2i = Card::RANKS.index(r2)
      next nil if r1i == r2i || r1i == nil || r2i == nil
      r1i <=> r2i
    end.compact.first || 0
  end
  def ==(other)
    return false unless other.is_a?(Hand)
    other.category == category && other.tiebreak_ranks == tiebreak_ranks
  end

  #TODO tie breaker cards
  protected
    def validate
      raise "A Hand must have 5 uniq cards, you have #{cards.size}: #{cards.join(",")}" if cards.size != 5
    end
    def detect_category
      #detect each hand
      #royal flush starts with 10, ends with A and has only 1 suit
      if uniq_ranks.size == 5 && low_rank == 10 && high_rank == "A" && suit_count == 1
        @tiebreak_ranks = [high_rank] #tie break would be high card
        :royal_flush
      #striaght flush, 5 uniq ranks and they're sequential and only 1 suit
      elsif uniq_ranks.size == 5 && high_rank_index - low_rank_index == 4 && suit_count == 1
        @tiebreak_ranks = [high_rank] #tie break would be high card
        :straight_flush
      #four of a kind, have 4 of 1 rank
      elsif rank_counts.include?(4)
        @tiebreak_ranks = [
          rank_histogram.keys.detect{|k| rank_histogram[k] == 4},
          rank_histogram.keys.detect{|k| rank_histogram[k] != 4}
        ]
        :four_of_a_kind
      #full house, have 2 of one rank and 3 of another
      elsif rank_counts == [2,3]
        #tie break by the rank that has 3 and the rank of 2
        @tiebreak_ranks = [
          rank_histogram.keys.detect{|k| rank_histogram[k] == 3},
          rank_histogram.keys.detect{|k| rank_histogram[k] == 2}
        ]
        :full_house
      #flush, 1 uniq suit
      elsif suit_count == 1
        @tiebreak_ranks = [high_rank] #tiebreak by high card
        :flush
      #straight, 5 uniq ranks and they're sequential and only 1 suit
      elsif uniq_ranks.size == 5 && high_rank_index - low_rank_index_with_ace == 4
        @tiebreak_ranks = [high_rank] #tiebreak by high card
        :straight
      #three_of_a_kind, have 3 of 1 rank
      elsif rank_counts.include?(3)
        @tiebreak_ranks = [high_rank] #tiebreak by high card
        :three_of_a_kind
      #two pair, 1 of 1 rank, 2 of 2 others
      elsif rank_counts == [1,2,2]
        #tie break by the 2 pairs thent he single
        @tiebreak_ranks = [
          rank_histogram.keys.select{|k| rank_histogram[k] == 2}.reverse, #high pair first
          rank_histogram.keys.detect{|k| rank_histogram[k] == 1}
        ].flatten
        :two_pair
      #pair, 1 of the ranks has 2
      elsif rank_counts.include?(2)
        pair_rank = rank_histogram.keys.select{|k| rank_histogram[k] == 2} #pair has count 2
        #take the non-pair cards in reverse order
        @tiebreak_ranks = [pair_rank] + (rank_histogram.keys - [pair_rank]).reverse
        :one_pair
      else
        @tiebreak_ranks = [high_rank]
        :high_card
      end
    end
end
