module Moving
  def walk
    "#{name} #{gait} forward."
  end
end

class Person
  include Moving
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Moving
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Moving
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end

# Write one method to do this:

mike = Person.new("Mike")
p mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
p kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
p flash.walk
# => "Flash runs forward"