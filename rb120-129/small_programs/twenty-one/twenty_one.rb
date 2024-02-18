# 45+30+15 - 2/14/24
def clear
  system 'clear'
  sleep 0.5
end

def prompt(msg)
  puts "=> #{msg}"
  sleep 0.5
end

module Displayable
  def display_welcome_message
    clear
    puts "-- Welcome to Twenty-One game --"
    gets
  end

  def display_goodbye_message
    puts "Thanks for playing Twenty-One. Goodbye!"
  end
end

class Participant
  attr_accessor :hand

  def initialize(type)
    @type = type
    @hand = Hand.new
  end

  def draw(deck)
    hand << deck.pop
  end

  def bust?
    hand.total_value > 21
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
    hand_values = convert_to_hand_values
    adjust_ace_value(hand_values.sum)
  end

  def adjust_ace_value(hand_sum)
    ace_count = cards.count do |card|
      card.rank == 'A'
    end
    ace_count.times do
      hand_sum -= 10 if hand_sum > 21
    end
    hand_sum
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
    cards[1..-1].map do
      "? of ?"
    end.join(', ')
  end

  def convert_to_hand_values
    cards.map do |card|
      if %w(J Q K).include?(card.rank)
        10
      elsif card.rank == 'A'
        11
      else
        card.rank.to_i
      end
    end
  end
end

class TwentyOne
  include Displayable

  def initialize
    @player = Participant.new(:player)
    @dealer = Participant.new(:dealer)
    @deck = new_deck
  end

  def play
    display_welcome_message
    loop do
      deal
      player_turn
      dealer_turn unless player.bust?
      display_results
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  attr_accessor :deck
  attr_reader :player, :dealer

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
    display_hands
  end

  def display_hands(reveal_dealers: false)
    sleep 0.5
    puts "Player Hand: #{player.hand}"
    dealers_hand = reveal_dealers ? dealer.hand : dealer.hand.show_one_card
    puts "Dealer Hand: #{dealers_hand}"
  end

  def prompt_hit_stay
    loop do
      puts "Would you like to (h)it or (s)tay?"
      input = gets.chomp[0].downcase
      return input if %(h s).include?(input)
      puts "Please enter h or s."
    end
  end

  def player_hit
    prompt "You hit!"
    player.draw(deck)
    display_hands
  end

  def player_turn
    loop do
      case prompt_hit_stay
      when 'h'
        player_hit
        break if player.bust?
      when 's'
        prompt "You decided to stay."
        break
      end
    end
  end

  def dealer_turn
    puts "Dealer's turn..."
    until dealer.hand.total_value >= 17
      dealer.draw(deck)
      prompt "Dealer decided to hit."
    end
    prompt "Dealer decided to stay." unless dealer.bust?
  end

  def display_winner
    case player.hand.total_value <=> dealer.hand.total_value
    when 1 then prompt "Player won!"
    when -1 then prompt "Dealer won!"
    when 0 then prompt "It's a tie!"
    end
  end

  def display_results
    if player.bust?
      prompt "You busted. Dealer won!"
    elsif dealer.bust?
      prompt "Dealer busted. You win!"
    else
      display_winner
    end
    puts "\nPlayer total: #{player.hand.total_value}\n" \
         "Dealer total #{dealer.hand.total_value}"
    puts display_hands(reveal_dealers: true)
  end

  def reset
    self.deck = new_deck
    player.hand = Hand.new
    dealer.hand = Hand.new
    clear
  end

  def play_again?
    input = ''
    loop do
      prompt "Would you like to play again? (y/n)"
      input = gets.chomp.downcase[0]
      break if %w(y n).include?(input)
      prompt "Sorry, that's not valid."
    end
    reset if input == 'y'
    input == 'y'
  end
end

TwentyOne.new.play
