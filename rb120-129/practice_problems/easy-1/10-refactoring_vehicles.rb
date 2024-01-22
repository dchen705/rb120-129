# Refactor these classes so they all use a common superclass, and inherit behavior as needed.

class Vehicle
  attr_reader :make, :model
  
  def initialize(make, model)
    @make = make
    @model = model
  end
  
  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  def wheels
    4
  end
end

class Motorcycle < Vehicle
  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end

Further Exploration

Would it make sense to define a wheels method in Vehicle even though all of the remaining classes would be overriding it? Why or why not? If you think it does make sense, what method body would you write?

We could do something like this:
class Vehicle
  def wheels(num)
    num
  end
end

class Car < Vehicle
  def wheels
    super(4)
  end
end

^ actually no, that just makes it too complicated.
Someone suggested this:
have a inherited wheels method from superclass `Vehicle` that returns the WHEEL_COUNT constant
for the class of that instance.
  
class Vehicle

  def wheels
    self.class::WHEEL_COUNT
  end

end

class Car < Vehicle
  WHEEL_COUNT = 4
end