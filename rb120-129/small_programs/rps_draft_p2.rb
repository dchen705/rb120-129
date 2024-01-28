# # My process for `choose`
# class Player
  
#   attr_reader :move
  
#   def initialize(name)
#     @name = name
#     @move = ''
#   end
  
#   def choose
#     @move = Move.new(@name).choice
#     puts @move
#   end
# end

# class Move
#   VALID_CHOICES = %w(rock paper scissors)
#   attr_reader :choice
#   def initialize(name)
#     if name == "Player"
#       loop do
#         puts "Please select your move from following: #{VALID_CHOICES}"
#         input = gets.chomp.downcase
#         if VALID_CHOICES.include?(input)
#           @choice = input
#           break
#         end
#         puts "Sorry, that's not a valid choice..."
#       end
#     else
#       @choice = VALID_CHOICES.sample
#     end
#   end
# end

# class Rule
  
# end

# def compare(move1, move2)
  
# end

# class RPSGame
#   attr_accessor :human, :computer

#   def initialize
#     @human = Player.new
#     @computer = Player.new
#   end

#   def play
#     display_welcome_message
#     human.choose
#     computer.choose
#     display_winner
#     display_goodbye_message
#   end
# end

# player = Player.new("Player")
# player.choose
# computer = Player.new("Not Player")
# computer.choose

# Part 2:
# def display_winner
#   if human.move == 'rock' && computer.move == 'scissors' ||
#     human.move == 'paper' && computer.move == 'rock' ||
#     human.move == 'scissors' && computer.move == 'paper'
#     puts "You won!"
#   elsif human.move == computer.move
#     puts "It's a draw!"
#   else
#     puts "You lost!"
#   end
# end
# actually human should be @human to allow a state/instance variable which accessible
# between instance methods

# # LS process for `choose`

# class Player
#   attr_accessor :move, :name
#   def initialize
#     set_name
#   end
# end

# class Human < Player
#   def set_name
#     input = ''
#       loop do
#         puts "What's your name?"
#         input = gets.chomp
#         break unless input.empty?
#         puts "Your name cannot be blank. Please try again."
#       end
#       self.name = input
#   end
  
#   def choose
#     choice = nil
#       loop do
#         puts "Please choose rock, paper, or scissors:"
#         choice = gets.chomp
#         break if %w(rock paper scissors).include?(choice)
#         puts "Sorry, invalid choice"
#       end
#       self.move = choice
#   end
# end

# class Computer < Player
#   def set_name
#     self.name = %w(Computer CPU).sample
#   end
  
#   def choose
#     self.move = %w(rock paper scissors).sample
#   end
# end

# class RPSGame
#   attr_accessor :human, :computer

#   def initialize
#     @human = Human.new
#     @computer = Computer.new
#   end
  
#   def display_welcome_message
#     puts "Welcome to Rock, Paper, Scissors!"
#   end
  
#   def display_goodbye_message
#     puts "Thanks for playing Rock, Paper, Scissors!"
#   end
  
#   def display_winner
#     puts "#{human.name} chose #{human.move}."
#     puts "#{computer.name} chose #{computer.move}."
#     if you_win?
#       puts "#{human.name} won!"
#     elsif human.move == computer.move
#       puts "It's a draw!"
#     else
#       puts "#{human.name} lost!"
#     end
#   end
  
#   def you_win?
#     human.move == 'rock' && computer.move == 'scissors' ||
#     human.move == 'paper' && computer.move == 'rock' ||
#     human.move == 'scissors' && computer.move == 'paper'
#   end
  
#   def play_again?
#     input = ''
#     loop do
#       puts "Do you want to play again? (y/n)"
#       input = gets.chomp
#       return true if input.start_with?('y') 
#       return false if input.start_with?('n')
#       puts "Sorry, invalid answer."
#     end
#   end

#   def play
#     display_welcome_message
#     loop do
#       human.choose
#       computer.choose
#       display_winner
#       break unless play_again?
#     end
#     display_goodbye_message
#   end
# end

# RPSGame.new.play

# the way he handled 2 branch logic for `choose` for player vs computer
# was he differentiated at the point of `player` instantiation
# then built the flow of player creation into the `RPSGame` instance

# My way was branching the logic at player instantiation too but 
# I didn't utilize the `initialize` of the RPSGame which seems 
# to defeat purpose of making the RPSgame object.

# SO one OOP heuristic I've learned is rather than in pure
# procedural, where the game flows start in the outer scope.
# here in his OOP example, game flow starts enclosed within 
# an engine orchestration object.

# another choice is he kept the choose logic in `choose` of Player
# instead of `move` initialize which I think makes sense
# also, he abstracted the verifcation of if human into a helper method

# he makes good observation that by putting `decide_winner` and `initialize` (w/ player collaborators)
# into same RPSGame object, no need to pass any objects into `decide_winner`

# Design Change # 1
# Substitute the conditional check for "Player" to decide between `choose` process w/
# 2 sub-classes, Human and Computer that have `choose` methods that override Player superclass and differ
# but inherit from the remaining methods from Player
#   Main advantage: simplifies, no longer need to pass a symbol/string object to flag a Human Player upon
#   instantiation, consequently no player_type parameter required and no conditional checks required for each
#   method like `choose`, `set_name`, and more if we add.. Instead the polymorphism? occurs at the
#   level of differentiation of two diff subclasses of Player. 
#   Another thing I like is it kinda organizes the code.
  
#   Main drawback: hmm, not sure. guess to me, but i suppose this applies to inheritance class in general,
#   it generally becomes harder to trace the states/behaviors esp if they were inherited from a 
#   superclass, so I suppose readability is lost...though that might be subjective too. Like i said
#   before, depends if you find that type of code organization preferable or not.
  
#   In this case, I think the pro outweight the con for turning into 2 subclasses,
#   the simplification of code w/o much drawback is nice.
  
#   Design Change # 2 (below)
  
#   idea is:
#   if human.move > computer.move
#     puts ''
#   elsif human.move < computer.move
    
#   I''m curious how they do it... do they just extract out the if / case statement logic to 
#   a helper method or an instance method of a new class?
  
class Move
  VALUES = %w(rock paper scissors)
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
  
  def >(other_move)
    case
    when rock?
      return true if other_move.scissors?
      return false
    when paper?
      return true if other_move.rock?
      return false
    when scissors?
      return true if other_move.paper?
      return false
    end
  end
  
  def <(other_move)
    case
    when rock?
      return true if other_move.paper?
      return false
    when paper?
      return true if other_move.scissors?
      return false
    when scissors?
      return true if other_move.rock?
      return false
    end
  end

def to_s
    @value
end

end

class Player
  attr_accessor :move, :name
  def initialize
    set_name
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
        puts "Please choose rock, paper, or scissors:"
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
    puts "Welcome to Rock, Paper, Scissors!"
  end
  
  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors!"
  end
  
  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    # if you_win?
    #   puts "#{human.name} won!"
    # elsif human.move == computer.move
    #   puts "It's a draw!"
    # else
    #   puts "#{human.name} lost!"
    # end
  end
  
  # def you_win?
  #   human.move == 'rock' && computer.move == 'scissors' ||
  #   human.move == 'paper' && computer.move == 'rock' ||
  #   human.move == 'scissors' && computer.move == 'paper'
  # end
  
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

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play

# Design Change #2
Inspiration was to replace case/if statement logic for `display_winner` to this:
if human.move > computer.move
  puts "#{human.name} won!"
elsif human.move < computer.move
  puts "#{computer.name} won!"
  
To design this, 2 main things were done.
- A class called Move was created and given an attribute of @value for 'rock', 'paper', or 'scissors'
- 2 methods, < and > were created in Move.
if you''re wondering what happend to the case statmeents/if statemnts - they actually basically
  got split up and added to the 2 new methods.
  
I suppose the main advantage is the `display_winner` method logic became easier to read
however, the draw back was the readability (having to trace back to another class called Move
to figure out the logic for Move.> and Move.<)
imo - the drawbacks outweight the pros becuz on top of harder traceability (indirection as they call it)
the case statement also seemed to double in size and less concise syntax wise due to spliting
to 2 methods.

Course says:
when it comes to object-oriented design, there is always a tradeoff between flexible code and indirection. On one hand, we can have all the code in one place, but then we lose flexibility. On the other hand, we can refactor the code for increased flexibility and maintainability. However, the tradeoff is increased indirection, which means that you have to dig deeper to fully understand what is happening.