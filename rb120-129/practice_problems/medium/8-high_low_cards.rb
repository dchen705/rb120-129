class Card
  attr_reader :rank, :suit

  include Comparable

  RANKS_TO_VALUES = {
  'Jack' => 11,
  'Queen' => 12,
  'King' => 13,
  'Ace' => 14,
  }.freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  protected

  def value
    case rank
    when (2..10) then rank
    else RANKS_TO_VALUES[rank]
    end
  end
end

cards = [Card.new(2, 'Hearts'),
         Card.new(10, 'Diamonds'),
         Card.new('Ace', 'Clubs')]
puts cards
puts cards.min == Card.new(2, 'Hearts')
puts cards.max == Card.new('Ace', 'Clubs')

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
         Card.new(4, 'Diamonds'),
         Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
         Card.new('Jack', 'Diamonds'),
         Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'

cards = [Card.new(8, 'Diamonds'),
         Card.new(8, 'Clubs'),
         Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8

# FE
# class Card
#   attr_reader :rank, :suit

#   include Comparable

#   RANKS_TO_VALUES = {
#   'Jack' => 11,
#   'Queen' => 12,
#   'King' => 13,
#   'Ace' => 14,
#   }.freeze

#   SUITS_TO_VALUES = {
#   'Diamonds' => 1,
#   'Clubs' => 2,
#   'Hearts' => 3,
#   'Spades' => 4
#   }.freeze

#   def initialize(rank, suit)
#     @rank = rank
#     @suit = suit
#   end

#   def to_s
#     "#{rank} of #{suit}"
#   end

#   def <=>(other_card)
#     if rank_value == other_card.rank_value
#       suit_value <=> other_card.suit_value
#     else
#       rank_value <=> other_card.rank_value
#     end
#   end

#   protected

#   def rank_value
#     case rank
#     when (2..10) then rank
#     else RANKS_TO_VALUES[rank]
#     end
#   end

#   def suit_value
#     SUITS_TO_VALUES[suit]
#   end
# end

# cards = [Card.new(4, 'Hearts'),
#          Card.new(4, 'Diamonds')
#          ]
# puts cards.min
# puts cards.max
