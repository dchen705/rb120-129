# this took pretty long, over 45 min cuz I had to figure out stuff like how
# Hash.new worked and what puts hash actually printed
# also learned that assigning instance vars outside a method call doesn't work.

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

# Write the classes and methods that will be necessary to make this code run, and print the following output:

P Hanson has adopted the following pets:
a cat named Butterscotch
a cat named Pudding
a bearded dragon named Darwin

B Holmes has adopted the following pets:
a dog named Molly
a parakeet named Sweetie Pie
a dog named Kennedy
a fish named Chester

P Hanson has 3 adopted pets.
B Holmes has 4 adopted pets.

# The order of the output does not matter, so long as all of the information is presented.

First Approach which failed.

class Owner
  attr_reader :name
  attr_writer :number_of_pets
  @number_of_pets = 0
  def initialize(name)
    @name = name
  end
end

class Pet 
  attr_reader :type, :name
  def initialize(type, name)
    @type = type.downcase
    @name = name
  end
end

class Shelter
  attr_accessor :owner_pet_dir
  @owner_pet_dir = Hash.new([])
  def adopt(owner, pet)
    owner_pet_dir[owner.name] << [pet.type, pet.name]
  end
  
  def print_adoptions
    puts owner_pet_dir
  end
end

Successful Approach

class Owner
  attr_reader :name
  attr_accessor :number_of_pets
  def initialize(name)
    @name = name
    @number_of_pets = 0
  end
end

class Pet 
  attr_reader :type, :name
  def initialize(type, name)
    @type = type.downcase
    @name = name
  end
end

class Shelter
  attr_accessor :owner_pet_dir
  def initialize
    self.owner_pet_dir = Hash.new { |hash, key| hash[key] = [] }
  end
  def adopt(owner, pet)
    @owner_pet_dir[owner.name] << [pet.type, pet.name]
    owner.number_of_pets += 1
  end
  
  def print_adoptions
    owner_pet_dir.each do |owner, pet_list|
      puts "#{owner} has adopted the following pets:"
      pet_list.each do |type, name|
        puts "a #{type} named #{name}"
      end
      puts
    end
  end
end

ANS KEY:
I found it interesting tech how they use the to_s override method for the Pet class and
a pet list in Owner Class to iterate through to generate the strings of "a #{type} named #{name}"
class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{animal} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end

  def print_pets
    puts pets
  end
end

class Shelter
  def initialize
    @owners = {}
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    @owners[owner.name] ||= owner
  end

  def print_adoptions
    @owners.each_pair do |name, owner|
      puts "#{name} has adopted the following pets:"
      owner.print_pets
      puts
    end
  end
end

Further Exploration

Add your own name and pets to this project.

Suppose the shelter has a number of not-yet-adopted pets, and wants to manage them through this same system. Thus, you should be able to add the following output to the example output shown above:

The Animal Shelter has the following unadopted pets:
a dog named Asta
a dog named Laddie
a cat named Fluffy
a cat named Kat
a cat named Ben
a parakeet named Chatterbox
a parakeet named Bluebell
   ...

P Hanson has 3 adopted pets.
B Holmes has 4 adopted pets.
The Animal shelter has 7 unadopted pets.


High Level approaches:
- manually store each pet instance, add them to a list, then iterate through that list: calling add to shelter method on each (which concats them to a array instance variable named `unadopted`)
  then for each Shelter.adopt call - remove the adopted pet from the unadopted list.

- remove the Pet class entirely and just have an `add_unadopted` method to the shelter method.

- add an `add_to_shelter` method to the `initialize` of each Pet instance -> I think this is the most efficient way.
one issue i kinda forgot - i'd need to pass the shelter obj in to each #new call on Pet.'

Failed Attempt

class Owner
  attr_reader :name
  attr_accessor :number_of_pets
  def initialize(name)
    @name = name
    @number_of_pets = 0
  end
end

class Pet 
  attr_reader :type, :name
  def initialize(type, name)
    @type = type.downcase
    @name = name
    add_to_shelter(shelter)
  end

  def add_to_shelter(shelter)
    shelter.unadopted << self
  end
end

class Shelter
  attr_accessor :owner_pet_dir, :unadopted
  def initialize
    self.owner_pet_dir = Hash.new { |hash, key| hash[key] = [] }
    self.unadopted = []
  end

  def adopt(owner, pet)
    @owner_pet_dir[owner.name] << pet
    owner.number_of_pets += 1
    self.unadopted.delete(pet)
  end
  
  def print_adoptions
    owner_pet_dir.each do |owner, pet_list|
      puts "#{owner} has adopted the following pets:"
      pet_list.each do |pet|
        puts "a #{pet.type} named #{pet.name}"
      end
      puts
    end
  end
end


Other Student''s High Lvl Approaches
- using @adopted in Pets as an attribute, upon instantiation set to false, and set to true if adopt()
- using @@unadopted = [] in Pets <- this is the clever thing to do
  - within Pet `initialize` he did @@unadopted << self
  my intuition was telling me to include something in the Pet `initialize` so we don''t have to
  manually add each Pet to shelter. but I got caught up in having to have Pet belong in shelter
  in reality, some people figured out can just create a state within the Pet instance 
  or better yet, create a class variable to represent unadopted Pets, first good use of class variables I''ve seen.