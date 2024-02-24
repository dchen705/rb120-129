# issue with mine is guess_count doesn't reset if want to play call on same instance.
# they used constants for guess_count, range and messages which made code clearer.
# needed to change guessses to guess when only 1 remaining.
# class GuessingGame
#   def initialize
#     @guess_count = 7
#     @random_num = (1..100).to_a.sample
#   end

#   def play
#     until guess_count <= 0
#       puts "You have #{guess_count} guesses remaining."
#       input = nil
#       loop do
#         print "Enter a number between 1 and 100: "
#         input = gets.chomp.to_i
#         break if (1..100) === input
#         print "Invalid guess. "
#       end
#       self.guess_count -= 1
#       case input <=> random_num
#       when 1 then puts "Your guess is too high."
#       when -1 then puts "Your guess is too low."
#       else
#         puts "That's the number!"
#         puts "You have won!"
#         return
#       end
#     end
#     puts "You're outta guesses, you lost!"
#   end

#   private

#   attr_accessor :guess_count
#   attr_reader :random_num
# end

# Ans key inspired.

class GuessingGame
  MAX_GUESSES = 7
  RANGE = 1..100

  GUESS_RESULTS_TO_DISPLAY = {
  :high => "Your guess is too high.",
  :low => "Your guess is too low.",
  :match => "That's the number!"
  }.freeze

  def initialize
    @secret_number = nil
    @guess_count = nil
  end

  def reset
    self.guess_count = MAX_GUESSES
    self.secret_number = RANGE.to_a.sample
  end

  def play
    reset
    game_result = play_game
    if game_result == :match
      puts "You won!"
    else
      puts "You're outta guesses, you lost!"
    end
  end

  private

  attr_accessor :guess_count, :secret_number

  def display_remaining_guesses
    if guess_count == 1
      puts "You have #{guess_count} guess remaining."
    else
      puts "You have #{guess_count} guesses remaining."
    end
  end

  def play_game
    until guess_count <= 0
      display_remaining_guesses
      guess = guess_once
      self.guess_count -= 1
      guess_result = get_guess_result(guess)
      puts GUESS_RESULTS_TO_DISPLAY[guess_result]
      return guess_result if guess_result == :match
    end
    guess_result
  end

  def guess_once
    loop do
      print "Enter a number between 1 and 100: "
      input = gets.chomp.to_i
      return input if (1..100) === input
      print "Invalid guess. "
    end
  end

  def get_guess_result(guess)
    case guess <=> secret_number
    when 1 then :high
    when -1 then :low
    else :match
    end
  end
end
game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

# game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guess remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!