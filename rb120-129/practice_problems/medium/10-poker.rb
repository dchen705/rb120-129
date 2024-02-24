# Include Card and Deck classes from the last two exercises.

class PokerHand
  ROYAL_FLUSH_CARDS = [10, 'Jack', 'Queen', 'King', 'Ace'].freeze

  def initialize(deck)
    @deck = deck
    @hand = []
    5.times { hand << deck.draw}
    @ranks = hand.map { |card| card.rank}
    @suits = hand.map { |card| card.suit}
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  attr_accessor :deck, :hand, :ranks, :suits

  def royal_flush?
    suits.all? { |suit| suit == suits[0]} && ROYAL_FLUSH_CARDS.all? do |royal_suit|
      ranks.include?(royal_suit)
    end
  end

  def straight_flush?
    sorted_values = hand.map { |card| card.value }.sort
    differences = sorted_values.map do |value|
      value - sorted_values[0]
    end
    differences == [0, 1, 2, 3, 4] && suits.all? { |suit| suit == suits[0]}
  end

  def four_of_a_kind?
    Deck::RANKS.any? { |rank| ranks.count(rank) == 4 }
  end

  def full_house?
    Deck::RANKS.any? { |rank| ranks.count(rank) == 3 } && Deck::RANKS.any? { |rank| ranks.count(rank) == 2 }
  end

  def flush?
    suits.all? { |suit| suit == suits[0]}
  end

  def straight?
    sorted_values = hand.map { |card| card.value }.sort
    differences = sorted_values.map do |value|
      value - sorted_values[0]
    end
    differences == [0, 1, 2, 3, 4]
  end

  def three_of_a_kind?
    Deck::RANKS.any? { |rank| ranks.count(rank) == 3}
  end

  def two_pair?
    Deck::RANKS.count do |rank|
      ranks.count(rank) == 2
    end == 2
  end

  def pair?
    Deck::RANKS.any? { |rank| ranks.count(rank) == 2}
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    new_deck
  end

  def draw
    if cards.empty?
      new_deck
      cards.pop
    else
      cards.pop
    end
  end

  private

  attr_accessor :cards

  def new_deck
    self.cards = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end
    cards.shuffle!
  end
end

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

  def value
    case rank
    when (2..10) then rank
    else RANKS_TO_VALUES[rank]
    end
  end
end

# TEST

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'