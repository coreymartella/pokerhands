#!/usr/bin/env ruby

require './lib/hand.rb'
if ARGV.size == 1 && ARGV[0] =~ /-*h(elp)?/
  puts "invoke with\n\tpoker.rb [HAND1 [HAND2]]\nwhere each HAND is a comma delimited list of cards e.g: \"9H,10D,AS,2H,3C\", if blank random hands will be generated"
  exit
end

hand1 = Hand.new(ARGV[0])
hand2 = Hand.new(ARGV[1])
result = Hand.winner(hand1, hand2)

if result == :draw
  puts "#{result} (#{hand1.category})"
else
  puts "#{result} (#{[hand1,hand2].sort.reverse.join(" beats ")})"
end
