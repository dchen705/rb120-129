class GuessingGame
  GUESS_RESULTS_TO_DISPLAY = {
  :high => "Your guess is too high.",
  :low => "Your guess is too low.",
  :match => "That's the number!"
  }.freeze

  def initialize(low, high)
    @secret_number = nil
    @guess_count = nil
    @range = low..high
    @max_guesses = Math.log2(@range.size).to_i + 1
  end

  def reset
    self.guess_count = max_guesses
    self.secret_number = range.to_a.sample
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
  attr_reader :range, :max_guesses

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
      print "Enter a number between #{range.first} and #{range.last}: "
      input = gets.chomp.to_i
      return input if range.cover?(input)
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

game = GuessingGame.new(501, 1500)
game.play

# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 104
# Invalid guess. Enter a number between 501 and 1500: 1000
# Your guess is too low.

# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 1250
# Your guess is too low.

# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 1375
# Your guess is too high.

# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 80
# Invalid guess. Enter a number between 501 and 1500: 1312
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 1343
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 1359
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 1351
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 1355
# That's the number!

# You won!

# game.play
# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 1000
# Your guess is too high.

# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 750
# Your guess is too low.

# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 875
# Your guess is too high.

# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 812
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 843
# Your guess is too high.

# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 820
# Your guess is too low.

# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 830
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 835
# Your guess is too low.

# You have 2 guesses remaining.
# Enter a number between 501 and 1500: 836
# Your guess is too low.

# You have 1 guess remaining.
# Enter a number between 501 and 1500: 837
# Your guess is too low.

# You have no more guesses. You lost!