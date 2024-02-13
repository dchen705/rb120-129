class Participant
    def initialize
        @hand = Hand.new
    end

    def bust

    end

    def stay

    end
end

class Player < Participant

end

class Dealer < Participant

end

class Card
    def initialize(rank, suit)
        @rank = rank
        @suit = suit
        @reveal_status = false
    end
end

class Hand
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
end

# Class Deck?
# what do w/ Deck?
# has 52 Cards initially,
# is an ordered list suggesting array
# within the 21Game:
@deck = []
double for or nested loop to concat each suit and rank to @deck
hmm shouldn''t both Player and Dealer have acess to Deck to hit?
Should Deck be a mix-in module then?
In OOP, tradeoff between loose coupling (like Player/Dealer to Deak through intermediate Game)
tight coupling (create Deck in Game then pass into initialization of Player/Dealer?)
but we prob doesn''t want to suggest Player has Deck....

class 21Game
    display_welcome_message
    deal
    player_turn
        break if bust? || stay
    dealer_turn
        break if bust? || stay
    decide_winner
    display_good_message
end

# reassess what Hand and Deck should be