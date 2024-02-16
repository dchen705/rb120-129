# Error raised because in the Songbird class `initialize` method, we call super which by default takes
# all parameters passed into the enclosing initialize method and passes it to the Bird superclass''s initailize method
# and since the Bird superclass requires 2 parameters but Songbird `super` will provide 3, an error
# of given 3 aguments when expected 2 will be raised.
# To fix this, we an simply manually specify which the parameters to pass into super like so

# ans key: mentions the method lookup chain

# # FE:
# I don''t think the FlightlessBird `initialize` method is necessary as it is the same initialize method in
# functionality as its parent''s intiialize ethod which the FlightlessBird subclass would inherit from
# automaticaly if we leave out the intiialize method

class Animal
  def initialize(diet, superpower)
    @diet = diet
    @superpower = superpower
  end

  def move
    puts "I'm moving!"
  end

  def superpower
    puts "I can #{@superpower}!"
  end
end

class Fish < Animal
  def move
    puts "I'm swimming!"
  end
end

class Bird < Animal
end

class FlightlessBird < Bird
  def initialize(diet, superpower)
    super
  end

  def move
    puts "I'm running!"
  end
end

class SongBird < Bird
  def initialize(diet, superpower, song)
    super(diet, superpower)
    @song = song
  end

  def move
    puts "I'm flying!"
  end
end

# Examples

unicornfish = Fish.new(:herbivore, 'breathe underwater')
penguin = FlightlessBird.new(:carnivore, 'drink sea water')
robin = SongBird.new(:omnivore, 'sing', 'chirp chirrr chirp chirp chirrrr')

