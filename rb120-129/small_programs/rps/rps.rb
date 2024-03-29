def prompt(msg)
  sleep 0.5
  puts "=> #{msg}"
end

def display_welcome_message
  system 'clear'
  puts "=== Welcome to Rock, Paper, Scissors, Spock, Lizard! ==="
end

def display_goodbye_message
  prompt "Thanks for playing Rock, Paper, Scissors, Spock, Lizard!"
end

def menu_select
  loop do
    puts "Select a game mode: (press enter to see how-to-play)"
    puts "(1) Classic Mode"
    puts "(2) Boss Rush Mode"
    input = gets.chomp
    return input if input == '1' || input == '2'
    display_info
  end
end

# rubocop:disable Metrics/MethodLength
def display_info
  system 'clear'
  puts <<-RULES
Classic Mode: Play against a normal CPU and win by best-of.

Boss Rush Mode: Face off against 3 CPU, defeat each by figuring
out their attack pattern and winning three moves in a row.

---
You probably know...
Rock beats scissors, paper beats rock, scissors beats paper.

But...
Rock and scissors also beat lizard. Paper also beats spock.

And...
Spock beats rock and scissors.
Lizard beats paper and spock.

---
Press any key to exit.
  RULES
  gets
  system 'clear'
end
# rubocop:enable Metrics/MethodLength

def start_game
  display_welcome_message
  case menu_select
  when '1' then ClassicMode.new.play
  when '2' then BossRushMode.new.play
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
      prompt "Make your move from the following:"
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
  def choose
    self.move = Move.new(Move::OPTIONS.keys.sample)
  end
end

class Mimic < Player
  def choose(player_history = [])
    if player_history.empty?
      self.move = Move.new(Move::OPTIONS.keys.sample)
    else
      self.move = Move.new(player_history.last)
    end
  end
end

class ClassicMode
  BANNER_WIDTH = 27

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    system 'clear'
    prompt "Welcome to Classic Mode!"
    loop do
      play_moves
      display_banner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer

  def play_moves
    human.choose
    computer.choose
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
      prompt "Do you want to play again? (y/n)"
      input = gets.chomp
      return true if input.start_with?('y')
      return false if input.start_with?('n')
      puts "Sorry, invalid answer."
    end
  end
end

class BossRushMode
  BANNER_WIDTH = 27

  def initialize
    @human = Human.new
    @computer = Mimic.new
    @player_history = []
    @consq_wins = 0
    @boss_lvl = 1
  end

  def play
    system 'clear'
    prompt "Welcome to Boss Rush Mode!"
    loop do
      play_moves
      display_banner
      break unless play_again? && !grand_winner?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer, :round_num, :player_history

  def play_moves
    human.choose
    computer.choose(player_history)
    record_player_move
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
        puts player_history
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

  def record_player_move
    @player_history << human.move.value
  end
end

start_game

# STATIC GUI DRAFT:
# -----------------
# puts <<-BOARD
# ┌#{'─' * DISPLAY_WIDTH}┐
# │#{'You chose rock.'.center(DISPLAY_WIDTH)}│
# │#{'Computer chose scissors.'.center(DISPLAY_WIDTH)}│
# │#{'---'.center(DISPLAY_WIDTH)}│
# │#{'YOU'.center(DISPLAY_WIDTH)}│
# │#{'WIN'.center(DISPLAY_WIDTH)}│
# │#{'---'.center(DISPLAY_WIDTH)}│
# │#{'Player - Computer'.center(DISPLAY_WIDTH)}│
# │#{(score1 + ' '* 10 + score2).center(DISPLAY_WIDTH)}│
# └#{'─' * DISPLAY_WIDTH}┘

# BOARD

# outputs ->
# ┌───────────────────────────┐
# │      You chose rock.      │
# │ Computer chose scissors.  │
# │            ---            │
# │            YOU            │
# │            WIN            │
# │            ---            │
# │     Player - Computer     │
# │       0          1        │
# └───────────────────────────┘

# ^ this is essentially display_moves, display_outcome, display scores.

# puts 'TIE'
# puts '---'
# puts 'GAME!'
# puts scores
# puts Player: #{} :

# <<-CARD
#     +=====================+
#     |         YOU            |
#     |         WIN           |
#     |         ---         |
#     |    Player - Computer
#     |     1         0
#     CARD

# DISPLAY_WIDTH

# puts <<-BOARD
# ┌──────────────────────┐
# │                      │
# │                      │
# │                      │
# │                      │
# │                      │
# └──────────────────────┘

# BOARD

# def winning_rock?(move, other_move)
#     move.value == 'rock' &&
#       (other_move.value == 'scissors' || other_move.value == 'lizard')
#   end

#   def winning_paper?(move, other_move)
#     move.value == 'paper' &&
#       (other_move.value == 'rock' || other_move.value == 'spock')
#   end

#   def winning_scissors?(move, other_move)
#     move.value == 'scissors' &&
#       (other_move.value == 'paper' || other_move.value == 'lizard')
#   end

#   def winning_spock?(move, other_move)
#     move.value == 'spock' &&
#       (other_move.value == 'rock' || other_move.value == 'scissors')
#   end

#   def winning_lizard?(move, other_move)
#     move.value == 'lizard' &&
#       (other_move.value == 'paper' || other_move.value == 'spock')
#   end

# class Player
#   attr_accessor :move, :score

#   def initialize
#     @score = 0
#   end

#   def joinor(move_list)
#     "#{move_list[0..-2].join(', ')} or #{move_list[-1]}"
#   end

#   def move_select(choice)
#     case choice
#     when 'rock' then Rock.new
#     when 'paper' then Paper.new
#     when 'scissors' then Scissors.new
#     when 'spock' then Spock.new
#     when 'lizard' then Lizard.new
#     end
#   end
# end

# class Human < Player
#   def choose
#     choice = nil
#     loop do
#       puts "Please choose #{joinor(Move::VALUES)}."
#       choice = gets.chomp
#       break if Move::VALUES.include? choice
#       puts "Sorry, invalid choice"
#     end
#     self.move = move_select(choice)
#   end
# end

# class Computer < Player
#   def choose
#     choice = Move::VALUES.sample
#     self.move = move_select(choice)
#   end
# end
