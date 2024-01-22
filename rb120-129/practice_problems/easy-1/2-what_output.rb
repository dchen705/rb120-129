What output does this code print? Fix this class so that there are no surprises waiting in store for the unsuspecting developer.


class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    @name.upcase!
    "My name is #{@name}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name # outputs 'Fluffy'
puts fluffy # outputs "My name is Fluffy."
puts fluffy.name # outputs 'FLUFFY'
puts name # outputs 'FLUFFY'

# to avoid mutating `name` object instead within def to_s,
# def to_s
#   "My name is #{@name.upcase}."
# end


# Further Exploration

# What would happen in this case?

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name # outputs "42"
puts fluffy # outputs "My name is 42."
puts fluffy.name #outputs "42"
puts name # outputs 43

#to_s in #initialize will convert `name` object to a string before assigning to `@name` which prevents error being thrown later when we use `@name` object upcase. the first output is from return value of getter method of @name defined by attr_reader... second output is return value of to_s method which overrides default to_s - hence return value of that to_s is output. When we output next line, @name hasn't been mutated since we changed #to_s. `name` becomes 43 after it was incremented by 1 from 42.
