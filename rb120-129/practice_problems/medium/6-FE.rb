# What's benefit of having a Player class?
# inheritance, mix-in module or collaborator

# I think Player should be a collaborator of the GuessingGame.
# guess count and guess once should be part of player...

# after adding it I don't see the point, since it's a 1 player game.
# everywhere I do guess_count I have to do player.guess_count.

class Player
  attr_accessor :guess_count

  def initialize
    @guess_count = nil
  end

  def guess_once
    loop do
      print "Enter a number between 1 and 100: "
      input = gets.chomp.to_i
      return input if (1..100) === input
      print "Invalid guess. "
    end
  end
end
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
    @player = Player.new
  end

  def reset
    player.guess_count = MAX_GUESSES
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

  attr_accessor :guess_count, :secret_number, :player

  def display_remaining_guesses
    if player.guess_count == 1
      puts "You have #{player.guess_count} guess remaining."
    else
      puts "You have #{player.guess_count} guesses remaining."
    end
  end

  def play_game
    until player.guess_count <= 0
      display_remaining_guesses
      guess = player.guess_once
      player.guess_count -= 1
      guess_result = get_guess_result(guess)
      puts GUESS_RESULTS_TO_DISPLAY[guess_result]
      return guess_result if guess_result == :match
    end
    guess_result
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
