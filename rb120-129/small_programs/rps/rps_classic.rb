def prompt(msg)
  sleep 0.5
  puts "=> #{msg}"
end

module Displayable
  def display_welcome_message
    system 'clear'
    prompt "Welcome to Rock, Paper, Scissors, Spock, Lizard!"
  end

  def display_goodbye_message
    prompt "Thanks for playing Rock, Paper, Scissors, Spock, Lizard!"
  end
end

class Move
  OPTIONS = {
    'rock' => { beats: %w(scissors lizard), shortened: 'r', num: '1' },
    'paper' => { beats: %w(rock spock), shortened: 'p', num: '2' },
    'scissors' => { beats: %w(paper lizard), shortened: 'sc', num: '3' },
    'spock' => { beats: %w(rock scissors), shortened: 'sp', num: '4' },
    'lizard' => { beats: %w(paper spock), shortened: 'l', num: '5' }
  }

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def >(other_move)
    OPTIONS[value][:beats].include?(other_move.value)
  end

  def <(other_move)
    OPTIONS[other_move.value][:beats].include?(value)
  end

  def to_s
    value
  end
end

class Player
  attr_accessor :move, :score

  def initialize
    @score = 0
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      prompt "Please select from the following:"
      display_options
      choice = gets.chomp
      break if get_valid_option choice
      puts "Sorry, invalid choice"
    end
    convert_to_valid(choice)
    self.move = Move.new(choice)
  end

  private

  def joinor(move_list)
    "#{move_list[0..-2].join(', ')} or #{move_list[-1]}"
  end

  def display_options
    Move::OPTIONS.each do |name, info|
      puts "#{info[:num]}) #{name} (#{info[:shortened]})"
    end
  end

  def get_valid_option(choice)
    Move::OPTIONS.each do |name, info|
      if [name, info[:shortened], info[:num]].include? choice.downcase
        return name
      end
    end
    nil
  end

  def convert_to_valid(choice)
    choice.replace(get_valid_option(choice))
  end
end

class Computer < Player
  attr_accessor :name

  def initialize
    super
    self.name = %w(Computer CPU).sample
  end

  def choose
    self.move = Move.new(Move::OPTIONS.keys.sample)
  end
end

class RPSGame
  BANNER_WIDTH = 27

  include Displayable

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_num = 1
    @move_history = []
  end

  def play
    display_welcome_message
    loop do
      play_moves
      display_banner
      break unless play_again? && !grand_winner?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer, :round_num, :move_history

  def play_moves
    human.choose
    computer.choose
    record_moves
    self.round_num += 1
  end

  def display_banner
    display_moves
    display_outcome
    display_scores
  end

  def add_to_banner(text_line)
    text_line.center(BANNER_WIDTH)
  end

  def display_moves
    system 'clear'
    puts "┌#{'─' * BANNER_WIDTH}┐"
    puts "|#{add_to_banner("You chose #{human.move}.")}|"
    sleep 0.75
    puts "|#{add_to_banner("Computer chose #{computer.move}.")}|"
    puts "|#{add_to_banner('---')}|"
  end

  def decide_winner
    if human.move > computer.move
      'PLAYER (YOU)!'
    elsif human.move < computer.move
      'COMPUTER!'
    else
      "IT'S A DRAW!"
    end
  end

  def display_outcome
    winner = decide_winner
    sleep 0.5
    puts "|#{add_to_banner('THE WINNER IS...')}|"
    sleep 1
    puts "|#{add_to_banner(winner)}|"
    puts "|#{add_to_banner('---')}|"
  end

  def display_scores
    update_score
    human_score = human.score.to_s
    computer_score = computer.score.to_s
    sleep 0.5
    puts "|#{add_to_banner('Player - Computer')}|"
    puts "|#{add_to_banner(human_score + (' ' * 10) + computer_score)}|"
    puts "└#{'─' * BANNER_WIDTH}┘"
  end

  def update_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def play_again?
    input = ''
    loop do
      prompt "Do you want to play again? (y/n) (enter h for move history)"
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
    @move_history << "Player chose #{human.move}."
    @move_history << "#{computer.name} chose #{computer.move}."
    @move_history << "---"
  end
end

RPSGame.new.play