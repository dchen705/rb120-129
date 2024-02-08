Tic-tac-toe is played on a 3 x 3 gameboard between 2 players who alternate marking spaces. Winner is decided by whoever gets 3 marks in a row whether row, column, or diagonal.

nouns: gameboard, player, space, winner, mark, row
verbs: play, alternate, mark, decide

gameboard
has a: player, space, winner, row

behavior: plays the game, decides winner, checks for winning row

player
behavior: marks

# Spike

class TTTGame
def initialize
@human = Player.new(:human)
@computer = Player.new(:computer)
@gameboard = Gameboard.new
end

def play
loop
name yourself
select cpu option
initialize new gameboard
loop gameplay
decide winner
end
end


class Player
attr_reader :name
def initialize(player_type)
@type = player_type
end


def mark
# does Player mark the Gameboard or does TTTGame...leaning
# towards TTTGame cuz there's a has-a relationship.
end
end


class Gameboard
@spaces = [ ' ', ' ', ' '
' ', ' ', ' '
' ', ' ', ' '
]
end

Summary (general steps for OOP TTT)
description > organize nouns/verbs > classes > engine orchestration (play high level)
> flesh out each high-level within `play`:
- display board
- square marking
- player and computer choosing
- deciding winner
- displaying messages

course''s walkthrough of `play`
- display board
- set up Board and Square class
- human moves
- computer moves
- take turns
- break when board is full
- detect winner
- refactor detect winner
- play again

similar rough high level - they had broken down steps more

Course''s Spike:
class Board
  def initialize
    # we need some way to model the 3x3 grid. Maybe "squares"?
    # what data structure should we use?
    # - array/hash of Square objects?
    # - array/hash of strings or integers?
  end
end

class Square
  def initialize
    # maybe a "status" to keep track of this square's mark?
  end
end

class Player
  def initialize
    # maybe a "marker" to keep track of this player's symbol (ie, 'X' or 'O')
  end

  def mark

  end

  def play

  end
end

class TTTGame
  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts ''
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end
    display_result
    display_goodbye_message
  end
end