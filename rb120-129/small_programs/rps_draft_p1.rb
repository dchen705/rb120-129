Procedural 
  Write a high abstract level instructions list (framework, chronology)
  
  Categorize methods into components (isolate dependencies)
  
  Break down each high level into smaller helper methods
  
  Debug along the way
  
  *Differences from OOP:
    - organizing data by outer-method scope (things like scores) vs in-method scope (things like
    random computer move)
    - meticulous tracking of data and knowing what datas need to be passed into every method and what 
    data is outputted by method
  
vs OOP

classes and instances 
(template maker for instances w/ unique state of common attributes and common behaviors)


Rock Paper Scissors
- player chooses
- computer chooses
- decide winner

Struggling where to start...familiar feeling.

How do we use OOP in the instruction building process?...
  - storing a "move" as an attribute? then a player and computer would be instances of something?
  - common behavior == "select_move" but process differs between player and computer...what''s point then?
  - perhaps, the game state itself should be an object...so that score can be an attribute?
  
I''m going to peek at my old rps program...
Wow, the rps program is very short. 
Very few helper methods besides, `prompt`, `win?` and `display_winner`
main gameplay is just contained in a loop.
  - get and validate player input
  - make computer move
  - decide and display winner
  
Not making much epiphany after 30 min, gonna finally read the course material.

---
The classical approach to object oriented programming is:

Write a textual description of the problem or exercise.
Extract the major nouns and verbs from the description.
Organize and associate the verbs with the nouns.
The nouns are the classes and the verbs are the behaviors or methods.
---
two players select a move from three options, rock, paper or scissors.
winner is decided by this rule: rock beats scissors beats paper beats rock


nouns: players, moves, winner, rule
verbs: select, beats, decide, display

players: select

struggling to see what class decide, beats, display belong to...maybe a gameboard object?

---
Notice that in OO, we don't think about the game flow logic at all. It's all about organizing and modularizing the code into a cohesive structure - classes. After we come up with the initial class definitions, the final step is to orchestrate the flow of the program using objects instantiated from the classes. We won't worry about that final step yet.
'---

Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it''s a tie.
|
v
Nouns: player, move, rule
Verbs: choose, compare
|
v
Player
 - choose
Move
Rule

- compare

class Player
  def initialize
    #name, move?
  end
  
  def choose
    
  end
end

class Move
  def initialize
    
  end
end

class Rule
  
end

def compare(move1, move2)
  
end

Player.new('Player')
Player.new('Computer')

Orchestration Engine

After we''re done organizing nouns and verbs into classes, we need an "engine" of some sort to orchestrate the objects. This is where the procedural program flow should be. Let's call the "engine" class RPSGame. We want an easy interface to kick things off, so perhaps to play the game, we just instantiate an object and call a method called play, like this:'

RPSGame.new.play

Ok, so my intuition of having a overall gameboard obj was kinda leading me in right direction.
They''re verifying that the procedural flow programming present in pure procedural also exists in
OOP, they''re just is an extra initial step of organizing nouns and verbs.

class RPSGame
  def initialize

  end

  def play

  end
end

^ Starting from that skeleton, we can start to think about what objects are required in the play method to facilitate the game.

do we initialize player objects and rule objects within the RPSGame play method?

def play
  display_welcome_message
  human_choose_move
  computer_choose_move
  display_winner
  display_goodbye_message
end

interesting...so yes, it seems like all the procedural flow that goes into rps from previous exercise
went into this overall game instance object but within an instance method called `play`
Additionally, they abstract out into helper instance methods...

but that''s the thing I was thinking about when brainstorming. I was sorta expecting OOP to make
the flow more efficient. but it just seems like they just copied and pasted the flow into a
organization of object. so at the moment, I don''t see the benefit of OOP.

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end

. One of the hardest things to understand about OOP is that there is no absolute "right" solution. In OOP, it's all a matter of tradeoffs. However, there are absolutely wrong approaches. For now, your goal is to avoid the wrong approaches, and understand the core concepts of OOP. Don't worry about finding the most optimal architecture or design. Object oriented design and architecture is a huge topic in itself, and it's going to take years (maybe decades!) to master that.'

Some criticism of OOP - the banana held by gorilla and jungle with it. Relying on inheritance, forms
these unintended bonds with other data when you are trying to pass a piece of data around.
