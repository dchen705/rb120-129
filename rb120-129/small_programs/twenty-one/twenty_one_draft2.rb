# 1 hour of work - 2/12/24

module Displayable
  def display_welcome_message
    puts "Welcome to Twenty-One game"
    gets
  end
end

class Participant
  attr_reader :hand

  def initialize(type)
      @type = type
      @hand = Hand.new
  end

  def draw(deck)
    hand << deck.pop
  end

  def hit

  end

  def stay

  end
end

class Card
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  SUITS = %w(♦ ♣ ♥ ♠)

  attr_reader :rank, :suit

  def initialize(rank, suit)
      @rank = rank
      @suit = suit
  end
end

class Hand

  attr_reader :cards

  def initialize
      @cards = [] # array of Card objects
  end

  def <<(card)
      cards << card
  end

  def total_value
      sum
      adjust_ace_value
  end

  def adjust_ace_value

  end

  def show_one_card
    shown_card = "#{cards.first.rank} of #{cards.first.suit}"
    "#{shown_card}, #{hidden_cards}"
  end

  private

  def to_s
    cards.map do |card|
      "#{card.rank} of #{card.suit}"
    end.join(', ')
  end

  def hidden_cards
    cards[1..-1].map do |card|
      "? of ?"
    end.join(', ')
  end
end

# Class Deck?
# what do w/ Deck?
# has 52 Cards initially,
# is an ordered list suggesting array
# within the 21Game:
# @deck = []
# double for or nested loop to concat each suit and rank to @deck
# hmm shouldn''t both Player and Dealer have acess to Deck to hit?
# Should Deck be a mix-in module then?
# In OOP, tradeoff between loose coupling (like Player/Dealer to Deak through intermediate Game)
# tight coupling (create Deck in Game then pass into initialization of Player/Dealer?)
# but we prob doesn''t want to suggest Player has Deck....

class Game_21
  include Displayable

  def initialize
    @player = Participant.new(:player)
    @dealer = Participant.new(:dealer)
    @deck = new_deck
  end

  def new_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck.shuffle
  end

  def deal
    2.times do
      player.draw(deck)
      dealer.draw(deck)
    end
  end

  def display_hands
    puts "Player Hand: #{player.hand}"
    puts "Dealer Hand: #{dealer.hand.show_one_card}"
  end

  def play
    display_welcome_message
    deal
    display_hands
    puts @deck.size
  end

  private

  attr_reader :player, :dealer, :deck

  # player_turn
  #     break if bust? || stay
  # dealer_turn
  #     break if bust? || stay
  # decide_winner
  # display_good_message
end

# reassess what Hand and Deck should be

Game_21.new.play