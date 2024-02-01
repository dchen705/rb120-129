# rubocop:disable Layout/LineLength
# What would happen if we went even further and introduced 5 more classes, one for each move: Rock, Paper, Scissors, Lizard, and Spock. How would the code change? Can you make it work? After you're done, can you talk about whether this was a good design decision? What are the pros/cons?'

# gonna have to change the way player choosing initializes
# also gonna have to modify how comparison works - not going to be between same classes
# what if I had them inherit comparison from a superclass like Move?

# what about what stats and behaviors each of these unique move classes will have?

# Write now flow is like this
# RPSGame creates human and computer objects whom call `choose` which modifies their @move attribute
# then comparison made between their @moves...

# I feel like this defeats the purpose but if I add a method to the superclass parent Move
# that just returns the class name in string form
# then we'd be just comparing string to string as in original draft.

# first breakthrough
# can we have say a Rock object and a Paper object and compare them by their classes?
# p 'abc'.class == 'xzy'.class # ahh. this returns true
# so instead of needing @values, we can just use the #class method to differentiate.
# additionally, what if we had Rock#to_s return self.class

# component: input and randomizer generation of @move for human and computer
# case statement?

# component:

# flow draft (high abstraction):
# Choose
# - `human` `choose` - use case stament to assign @move to instantiation based on input
# - `computer` `choose` - hmm somehow rando generate, maybe rando from choices then case statement
#   ^ actually both those steps can use the same case statemnet method
# Comparison
# doesn't make sense to call a Move method and don't see much point to having Move superclass
# hmm, maybe I can use Move superclass and just keep the comparison methods in the Move superclas
# (within each rock, paper, etc. class)
# to_s returns self.class
# ie: 'abc'.class == String
# - call human.move.>(computer.move) #> method inherited from Move
#   - call winning_rock?(move, other_move)
#     move == Rock && (other_move == Scissors || etc..)
#     ^ it''s clear imo enough to not have to use the helper methods like rock?, scissors? etc..

# pro: the `value` of a move is built into the class itself so don't need to make instance variable
# even better using to_s so can avoid a getter method
# Ok, I realized something, we're not calling puts or method that auto does to_s like for string interpolation. can't set to_s to self.class

# con: input -> correct object requires an extra step

# summary (initial): w/o writing up yet, I think this design change the pros outweight the cons.
# hm, but i dunno, the classes Rock, Scissors, etc. will be fairly empty, will inherit
# most behaviors from Move and won't require main attr @value... in the end.. I dunno
# if classifying down to this is really necessary over just comparing string values from local var.

# summary (after implemenation): nah, making use of 5 class here instead of instance variables for
# move class seems pointless. we are adding bulk and not even using any functionality in the new classes
# ie: the Rock, Paper, etc. classes are literally empty, what'st the point.

# rubocop:enable Layout/LineLength
class Move
  VALUES = %w(rock paper scissors spock lizard)

  def winning_rock?(move, other_move)
    move.instance_of?(Rock) &&
      (other_move.instance_of?(Scissors) || other_move.instance_of?(Lizard))
  end

  def winning_paper?(move, other_move)
    move.instance_of?(Paper) &&
      (other_move.instance_of?(Rock) || other_move.instance_of?(Spock))
  end

  def winning_scissors?(move, other_move)
    move.instance_of?(Scissors) &&
      (other_move.instance_of?(Paper) || other_move.instance_of?(Lizard))
  end

  def winning_spock?(move, other_move)
    move.instance_of?(Spock) &&
      (other_move.instance_of?(Rock) || other_move.instance_of?(Scissors))
  end

  def winning_lizard?(move, other_move)
    move.instance_of?(Lizard) &&
      (other_move.instance_of?(Paper) || other_move.instance_of?(Spock))
  end

  def >(other_move)
    winning_rock?(self, other_move) ||
      winning_paper?(self, other_move) ||
      winning_scissors?(self, other_move) ||
      winning_spock?(self, other_move) ||
      winning_lizard?(self, other_move)
  end

  def <(other_move)
    winning_rock?(other_move, self) ||
      winning_paper?(other_move, self) ||
      winning_scissors?(other_move, self) ||
      winning_spock?(other_move, self) ||
      winning_lizard?(other_move, self)
  end

  def to_s
    self.class.to_s.downcase
  end
end

class Rock < Move
end

class Paper < Move
end

class Scissors < Move
end

class Spock < Move
end

class Lizard < Move
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def joinor(move_list)
    "#{move_list[0..-2].join(', ')} or #{move_list[-1]}"
  end

  def move_select(choice)
    case choice
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'spock' then Spock.new
    when 'lizard' then Lizard.new
    end
  end
end

class Human < Player
  def set_name
    input = ''
    loop do
      puts "What's your name?"
      input = gets.chomp
      break unless input.empty?
      puts "Your name cannot be blank. Please try again."
    end
    self.name = input
  end

  def choose
    choice = nil
    loop do
      puts "Please choose #{joinor(Move::VALUES)}."
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice"
    end
    self.move = move_select(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(Computer CPU).sample
  end

  def choose
    choice = Move::VALUES.sample
    self.move = move_select(choice)
  end
end

class RPSGame
  attr_accessor :human, :computer, :round_num, :move_history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_num = 1
    @move_history = []
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors! First to 10 wins."
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def human_win?
    human.move > computer.move
  end

  def computer_win?
    human.move < computer.move
  end

  def display_winner
    if human_win?
      puts "#{human.name} won!"
      human.score += 1
    elsif computer_win?
      puts "#{computer.name} won!"
      computer.score += 1
    else
      puts "It's a tie!"
    end
  end

  def display_scores
    puts "#{human.name} Score: #{human.score}"
    puts "#{computer.name} Score: #{computer.score}"
  end

  def play_again?
    input = ''
    loop do
      puts "Do you want to play again? (y/n) (enter h for move history)"
      input = gets.chomp
      if input.start_with?('h')
        puts move_history
        next
      end
      return true if input.start_with?('y')
      return false if input.start_with?('n')
      puts "Sorry, invalid answer."
    end
  end

  def grand_winner?
    human.score == 10 || computer.score == 10
  end
  
  def record_moves
    @move_history << "Round #{round_num}:"
    @move_history << "#{human.name} chose #{human.move}."
    @move_history << "#{computer.name} chose #{computer.move}."
    @move_history << "---"
  end
  
  def play_moves
    human.choose
    computer.choose
    record_moves
    display_moves
    self.round_num += 1
  end

  def play
    display_welcome_message
    loop do
      play_moves
      display_winner
      display_scores
      break unless play_again? && !grand_winner?
    end
    display_goodbye_message
  end
end

RPSGame.new.play

# Keep track of a history of moves

# As long as the user doesn't quit, keep track of a history of moves by both the human and computer. What data structure will you reach for? Will you use a new class, or an existing class? What will the display output look like?'

# I''m gonna reach for an array, ordered list, obviously... it''s gonna be a stat in the RPSGame
# instance
# gonna work like this:
# @round_num = 0
# @move_history = []
# RPSGame > record_moves()
# # [] << Round 1 << "Human chose _" << "Computer chose _" << '---'
# display will be line by line
# show_record will be in the play_again method

# Computer personalities

# We have a list of robot names for our Computer class, but other than the name, there's really nothing different about each of them. It'd be interesting to explore how to build different personalities for each robot. For example, R2D2 can always choose "rock". Or, "Hal" can have a very high tendency to choose "scissors", and rarely "rock", but never "paper". You can come up with the rules or personalities for each robot. How would you approach a feature like this?

# Like make a sub-class for each Computer type and each have different choose method? but what''s the point over
# a general case statement in the Computer class
# Or give an attribute holder that tracks the computer type and put the case statement in choose.
# ^ I think 2nd option makes more sense