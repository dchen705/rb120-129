require 'pry'
class Move
  VALUES = %w(rock paper scissors spock lizard)
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  # def >(other_move)
  #   (rock? && (other_move.scissors? || other_move.lizard?)) ||
  #     (paper? && (other_move.rock? || other_move.spock?)) ||
  #     (scissors? && (other_move.paper? && other_move.lizard?)) ||
  #     (spock? && (other_move.rock? || other_move.scissors?)) ||
  #     (lizard? && (other_move.paper? || other_move.spock?))
  # end

  # def <(other_move)
  #   (rock? && other_move.paper?) ||
  #     (paper? && other_move.scissors?) ||
  #     (scissors? && other_move.rock?)
  # end

  def winning_rock?(move, other_move)
    (move.rock? && (other_move.scissors? || other_move.lizard?))
  end

  def winning_paper?(move, other_move)
    (move.paper? && (other_move.rock? || other_move.spock?))
  end

  def winning_scissors?(move, other_move)
    (move.scissors? && (other_move.paper? || other_move.lizard?))
  end

  def winning_spock?(move, other_move)
    (move.spock? && (other_move.rock? || other_move.scissors?))
  end

  def winning_lizard?(move, other_move)
    (move.lizard? && (other_move.paper? || other_move.spock?))
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
    value
  end
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
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(Computer CPU).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
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
      puts "Do you want to play again? (y/n)"
      input = gets.chomp
      return true if input.start_with?('y')
      return false if input.start_with?('n')
      puts "Sorry, invalid answer."
    end
  end

  def grand_winner?
    human.score == 10 || computer.score == 10
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_scores
      break unless play_again? && !grand_winner?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
