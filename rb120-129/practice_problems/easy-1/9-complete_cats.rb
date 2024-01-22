# Update code so that when you run it, you see the following output:
# My cat Pudding is 7 years old and has black and white fur.
# My cat Butterscotch is 10 years old and has tan and white fur.

class Pet
  attr_reader :name, :age
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  attr_reader :fur_color
  def initialize(name, age, fur_color)
      super(name, age)
      @fur_color = fur_color
  end
  
  def to_s
    "My cat #{name} is #{age} years old and has #{fur_color} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch

Further Exploration

An alternative approach to this problem would be to modify the Pet class to accept a colors parameter. If we did this, we wouldn't need to supply an initialize method for Cat.

Why would we be able to omit the initialize method? Would it be a good idea to modify Pet in this way? Why or why not? How might you deal with some of the problems, if any, that might arise from modifying Pet?

If Pet class accepts colors parameter, then we can assign a Pet instance variable to the colors parameter
which thus gets inherited by Cat class and doesn''t need separate initialization.

Depends... but probably not a good idea if we cannot generalize the attribute fur_color to all subclasses that would
derive from Pet

not sure how to fix..
Other student:
Ah, if we supply 2 arguments to a 3 parameter initialize method - for example if Pet has @name, @age, @color
but Polar Bear < Pet only has @name, @age
so just override def initialize '

class Pet
  attr_reader :name, :age, :color

  def initialize(name, age, color)
    @name = name
    @age = age
    @color = color
  end
end

class Cat < Pet

  def to_s
    "My cat #{name} is #{age} years old and has #{color} fur."
  end

end

class PolarBear < Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

yogi = PolarBear.new('Yogi', 65)
p yogi.color #=> nil
