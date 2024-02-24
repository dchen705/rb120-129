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

  protected

  def value
    case rank
    when (2..10) then rank
    else RANKS_TO_VALUES[rank]
    end
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.