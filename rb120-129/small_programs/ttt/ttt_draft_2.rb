# rubocop:disable Layout/LineLength, Layout/CommentIndentation
# 4 + 1 + 1.5 + .25 (6.75) - 2/9/24
# 1.25 + 1 + 0.25 (2.5) - 2/11/24
# summary lessons:
# w/ OOP, I get confused when we start using objects... ie: a array of Square objects <-
# I'll assume it's a hash of String values.

# Add to Board and Square classes: 3 design details
# - link TTTGame to Board class w/ a "has-a" relatioship by initializing Board.new
#   - rather than passing board obj, @board is a state of TTTGame - can use in display_board
# - chooose structure of board - ie: hash w/ integer keys and ' ' as hash values or better yet...
# - link Board to Square
#   - initialize `squares` of Board to hash and use Square.new for every hash element of
#     ^ intuition - some state of Board instance called @squares that points to the
#     hash objet

# def human_moves
#   # desired logic - msg user, ask for then validate input, modify the board's squares status attr
#   # into Player marker -> do we create a Player class, if so what relation is @board to Player...
#   # hmm, if we don't create new Player, i feel would be easier...

#   # seems not subclassing Human and Computer, we are instantiating two different Person objects w/
#   diff marker arguments
#   we are not putting logic in TTTGame (though we can), actually, we can put into not just
#   Person class
#   ie: person.mark(board <- that''s the board obj)
#   we can do in Board class
#   ie board.set_square_at(position, marker)
#   ^ design choice: putting logic in engine orchestration or compartmentalizing it into a custom obj of the
#   engine that we instantiated...seems OOP is not comletely avoiding passing args into methods
# end

# Computer Move
  # randomly select from empty positions, then call set_square_at with comp marker

# Decide winner (struggling with custom object based data structures/collections:
# alternative detect_winner method
  # returns winning player's marker or nil, no parameter taken
  # works by calling helper methods that takes the board's specific squares of the current line
  # being checked and counting if squares are marked
  # in more detail for the helper, we are passing in via a * splat operator which gets the positions
  # in an array of the current line.
    # ^ hmm, not quite, i'm not exactly sure what they passed into the helper... think they somehow
    # filtered only the squares
  # remember each square object has a marker getter method which we can use with #map to then
  # count number of squares transformed into markers are equal to the player marker
  # okay ^ above is wrong, they're checking if return value of a helper method that returns count
  # of the three squares passed in are 3...
  # squares is a hash, but we only want to pass in an array of hash values of the three positions
  # designated by the current line of iteration. in order to do that
  # they call Hash#values_at on @squares passing in `*line` -> this works becuz `line` is an array
  # but values_at is a method that acccepts a series of arg each indicating indices and the splat
  # operator does that conversion of the array to the series of args
  # I forgot it's an array of square objects
  # def count_human_markers(squares)
  #   squares.map(&:status).count(TTTGame::HUMAN_MARKER)
  # end

  # def count_computer_markers(squares)
  #   squares.map(&:status).count(TTTGame::COMPUTER_MARKER)
  # end

  # def detect_winner (renamed to winning_marker)
  #   WINNING_LINES.each do |line|
  #     if count_human_markers(@squares.values_at(*line)) == 3
  #       return TTTGame::HUMAN_MARKER
  #     elsif count_computer_markers(@squares.values_at(*line)) == 3
  #       return TTTGame::COMPUTER_MARKER
  #     end
  #   end
  #   nil
  # end

  # good refactoring suggestions:
  # - putting board.display functionality as responsibility of Board
  # - calling board[square] = human.marker rather than board.set_square_at(position, marker)
    # think that's special idiomatic #[]= instance method
    # def set_square_at(position, marker)
    #   squares[position].status = marker
    # end
    # ->
    # def []=(position, marker)
    #   squares[position].status = marker
    # end
  # - generalize the `detect_winner`/`winning_marker` method so it''s not hardcoded to relying on
    # constants from TTTGame... esp considering method is in Board. Make the method return any marker
    # that wins
      # my idea:
        # iterate through winning lines:
          # next if any squares[position].status in `line` is equal to initial marker
          # if squares[line[0]].status == squares[line[0]].status &&
          #   squares[line[0]].status == squares[line[0]].status <- then by deduction
          #   all are equal, return that marker
          # when I saw this
          # squares[line[0]].status == squares[line[1]].status &&
          # squares[line[0]].status == squares[line[2]].status
          # I knew I could customize a Square#== method
        # In Square
        # def ==(other_square)
        #   self.status == other_square.status
        # end

        # In Board

        # def any_unmarked?(line)
        #   line.any? { |position| squares[position].status == INITIAL_MARKER}
        # end
        # def winning_marker
        #   WINNING_LINES.each do |line|
        #     next if any_unmarked?(line)
        #     if squares[line[0]] == squares[line[1]] &&
        #        squares[line[0]] == squares[line[2]]
        #       return squares[line[0]].status
        #     end
        #   end
        #   nil
        # end

        # wow pretty generalized, good refactored, passed rubocop:
        # made a method that can handle X size grids, not just 3 x 3 s by using #all? and splat operator.
        # see below:
        # def any_unmarked?(line)
        #   line.any? { |position| squares[position].status == INITIAL_MARKER }
        # end

        # def all_same?(line)
        #   squares.values_at(*line).all? do |square|
        #     square == squares[line[0]]
        #   end
        # end

        # def winning_marker
        #   WINNING_LINES.each do |line|
        #     next if any_unmarked?(line)
        #     if all_same?(line)
        #       return squares[line[0]].status
        #     end
        #   end
        #   nil
        # end
# rubocop:enable Layout/LineLength, Layout/CommentIndentation

class Board
  INITIAL_MARKER = ' '
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]
  CENTER_POSITION = 5

  attr_reader :squares

  def initialize
    # we need some way to model the 3x3 grid. Maybe "squares"?
    # what data structure should we use?
    # - array/hash of Square objects?
    # - array/hash of strings or integers?
    @squares = (1..9).each_with_object({}) do |position, squares|
      squares[position] = Square.new(INITIAL_MARKER)
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def display
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def [](position)
    squares[position].status
  end

  def []=(position, marker)
    squares[position].status = marker
  end

  def empty_positions
    squares.select do |_, square|
      square.status == INITIAL_MARKER
    end.keys
  end

# old method:

# def detect_winner(marker)
#   WINNING_LINES.each do |winning_line|
#     return true if winning_line.all? do |position|
#       squares[position].status == marker
#     end
#   end
#   false
# end

  def any_unmarked?(line)
    line.any? { |position| squares[position].status == INITIAL_MARKER }
  end

  def all_same?(line)
    squares.values_at(*line).all? do |square|
      square == squares[line[0]]
    end
  end

  def winning_marker
    WINNING_LINES.each do |line|
      next if any_unmarked?(line)
      if all_same?(line)
        return squares[line[0]].status
      end
    end
    nil
  end

  def count_human_markers(squares)
    squares.map(&:status).count(TTTGame::HUMAN_MARKER)
  end

  def count_computer_markers(squares)
    squares.map(&:status).count(TTTGame::COMPUTER_MARKER)
  end

  def at_risk_position
    WINNING_LINES.each do |line|
      if count_human_markers(@squares.values_at(*line)) == 2 && any_unmarked?(line)
        return line.find { |position| squares[position].status == INITIAL_MARKER }
      end
    end
    nil
  end

  def winning_position
    WINNING_LINES.each do |line|
      if count_computer_markers(@squares.values_at(*line)) == 2 && any_unmarked?(line)
        return line.find { |position| squares[position].status == INITIAL_MARKER }
      end
    end
    nil
  end
end

class Square
  attr_accessor :status

  def initialize(marker)
    # maybe a "status" to keep track of this square's mark?
    @status = marker
  end

  def to_s
    status
  end

  def ==(other_square)
    status == other_square.status
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    # maybe a "marker" to keep track of this player's symbol (ie, 'X' or 'O')
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  WINNING_SCORE = 5

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @human_score = 0
    @computer_score = 0
  end

  def play
    display_welcome_message
    prompt_who_first
    display_board(clear_screen: false)
    main_game
    display_goodbye_message
  end

  private

  attr_accessor :board, :current_player, :first_move_player, :human_score, :computer_score
  attr_reader :human, :computer

  def display_welcome_message
    clear
    puts 'Welcome to Tic Tac Toe!'
    puts "Play best of #{WINNING_SCORE}."
    puts ''
    gets
  end

  def display_prompt_who_first
    puts <<-PROMPT
Please select who goes first:
  1) Player
  2) Computer
  3) Random
    PROMPT
  end

  def set_first_move_player(option)
    case option
    when "1" then self.first_move_player = human
    when "2" then self.first_move_player = computer
    when "3" then self.first_move_player = [human, computer].sample
    end
  end

  def prompt_who_first
    input = nil
    loop do
      display_prompt_who_first
      input = gets.chomp
      break if %w(1 2 3).include?(input[0])
      puts "Sorry, that's not valid."
    end
    set_first_move_player(input)
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def clear
    system 'clear'
  end

  def display_board(clear_screen: true)
    clear if clear_screen
    puts "You are #{HUMAN_MARKER}"
    puts "Computer is #{COMPUTER_MARKER}"
    puts ""
    board.display
    puts ""
  end

  def joinor(positions, delimiter = ', ', ender = ' or')
    case positions.size
    when 1 then positions[0]
    when 2 then "#{positions[0]} or #{positions[1]}"
    else "#{positions[0..-2].join(delimiter)}#{ender} #{positions[-1]}"
    end
  end

  def human_moves
    empty_positions = board.empty_positions
    position = ''
    loop do
      puts "Please select a square from following: #{joinor(empty_positions)}"
      position = gets.chomp.to_i
      break if empty_positions.include?(position)
      puts "Sorry, that's not a valid input."
    end
    board[position] = human.marker
  end

  def play_offense
    if board.winning_position
      board[board.winning_position] = computer.marker
    else
      nil
    end
  end

  def play_defense
    if board.at_risk_position
      board[board.at_risk_position] = computer.marker
    else
      nil
    end
  end

  def play_center
    if board[Board::CENTER_POSITION] == Board::INITIAL_MARKER
      board[Board::CENTER_POSITION] = COMPUTER_MARKER
    else
      nil
    end
  end

  def play_random
    board[board.empty_positions.sample] = computer.marker
  end

  def computer_moves
    play_offense || play_defense || play_center || play_random
  end

  def current_player_moves
    if current_player == human
      human_moves
    else
      computer_moves
    end
  end

  def alternate_current_player
    self.current_player = current_player == human ? computer : human
  end

  def alternate_first_move_player
    self.current_player = first_move_player
    self.first_move_player = first_move_player == human ? computer : human
  end

  def players_move
    loop do
      current_player_moves
      break if someone_won? || board_full?
      display_board if current_player == computer
      alternate_current_player
    end
  end

  def board_full?
    board.empty_positions.empty?
  end

  def someone_won?
    # below is old method
    # return human if board.detect_winner(HUMAN_MARKER)
    # return computer if board.detect_winner(COMPUTER_MARKER)
    # nil
    !!board.winning_marker
  end

  def display_result
    display_board
    # winner = someone_won?
    case board.winning_marker
    when HUMAN_MARKER then puts "You won!"
    when COMPUTER_MARKER then puts "Computer won!"
    else puts "It's a tie!"
    end
  end

  def update_and_display_score
    case board.winning_marker
    when HUMAN_MARKER
      self.human_score += 1
    when COMPUTER_MARKER
      self.computer_score += 1
    end
    puts "Human : [#{human_score}] - [#{computer_score}] : Computer"
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    input = ''
    loop do
      input = gets.chomp
      break if ['y', 'n'].include?(input[0])
      puts "Sorry, that's not a valid input."
    end
    input.start_with?('y')
  end

  def reset
    self.board = Board.new
    clear
    puts "Ok, let's play again."
    puts ''
    display_board(clear_screen: false)
  end

  def grand_winner
    if human_score == WINNING_SCORE
      puts 'Congratulations, you are the grand winner!'
      true
    elsif computer_score == WINNING_SCORE
      puts 'Computer is the grand winner!'
      true
    end
    false
  end

  def main_game
    loop do
      alternate_first_move_player
      players_move
      display_result
      update_and_display_score
      break unless play_again? || grand_winner
      reset
    end
  end
end

TTTGame.new.play

# Refactor potential
# - remame the alternate_first_move_player to something more appropriate - something meaning
# we are setting current player to first move player then alternating the first move player
