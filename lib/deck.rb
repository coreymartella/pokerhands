require 'singleton'
class Deck
	include Singleton
	attr_reader :cards
	def initialize
		@cards = Card::RANKS.product(Card::SUITS).map(&:join).sort_by{Kernel.rand} 
	end
	def reset
		@cards = Card::RANKS.product(Card::SUITS).map(&:join).sort_by{Kernel.rand} 
	end
	def peek
  	#get a random card that is in the deck
  	@cards[0] if @cards.size > 0
  end
  def deal
    #pop the top card from the deck
    @cards.delete_at(0) if @cards.size > 0
  end
  def deal_card(card)
  	#remove a specific card from the deck
  	@cards.delete(card.to_s) || raise(ArgumentError, "card #{card} is not in deck, cannot be dealt")
  end
  def size
  	@cards.size
  end
end