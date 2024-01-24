# Modify the House class so that the above program will work. You are permitted to define only one new method in House.


class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

Expected OUTPUT
Home 1 is cheaper
Home 2 is more expensive

class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
  
  
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

Tricky for some reason. I''m assumign I can''t change the puts statements

Attempts:
- change define a method name self to control what self returns
- Can''t change value of `self` like this `self` = price

Damn, the hint blew my brain:
basically, i can mixin the Comparable module
and this statement home1 < home2
is essentially
home1.<(home2)
so instead of viewing it like < operator, it''s more like:
home 1 calls its < method passing in home2 as argument

class House
  include Comparable
  attr_reader :price

  def initialize(price)
    @price = price
  end
  
  def <=>(other)
    price <=> other.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

Weird to note: <=> definition seems to write algos for < and > methods both - haven''t seen something like this before
Is this a property of the Comparable mixin?

Further Exploration

Is the technique we employ here to make House objects comparable a good one? (Hint: is there a natural way to compare Houses? Is price the only criteria you might use?) What problems might you run into, if any? Can you think of any sort of classes where including Comparable is a good idea?

Ah this is what I was trying to do, as discoverd by another student:
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end

  def self.new(price)
    price
  end
end

