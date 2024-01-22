# Inheritance Exercises
# 1)

class Vehicle
  attr_accessor :gas, :mileage, :current_speed
  
  def initialize
    self.current_speed = 0
  end
  
  def accelerate(speed)
    self.current_speed += speed
  end
  
end

class MyCar < Vehicle
  MODEL_NUM = 123456
  
end

class MyTruck < Vehicle
  IS_HYBRID = true
  
end

2) 
Add a class variable to your superclass that can keep track of the number of objects created that inherit from the superclass. Create a method to print out the value of this class variable as well.

Below works, but I misread the prompt
 @@attribute_count = (attr_accessor :gas, :mileage, :current_speed).size / 2

  def self.display_attribute_count
    puts @@attribute_count
  end
  
It''s asking to count children objects that derive from Vehicle

class Vehicle
  attr_accessor :gas, :mileage, :current_speed
  @@vehicle_count = 0
  
  def initialize
    self.current_speed = 0
    @@vehicle_count += 1
  end
  
  def accelerate(speed)
    self.current_speed += speed
  end

  def self.print_vehicle_count
    puts @@vehicle_count
  end
  
end

class MyCar < Vehicle
  MODEL_NUM = 123456
end

class MyTruck < Vehicle
  IS_HYBRID = true
  
end

MyCar.new
MyTruck.new
MyCar.new
Vehicle.print_vehicle_count

3)Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to that subclass.

module VehicleRegister
  plate_registration = true
end
# notably module definition has to come before `include`

class MyCar < Vehicle
  MODEL_NUM = 123456
  EXPIRATION_YR = 2026
  include VehicleRegister if Time.now.year <= EXPIRATION_YR
end

# ANS key example
module Towable
  def can_tow?(pounds)
    pounds < 2000
  end
end

4)
puts MyCar.ancestors
puts '---'
puts MyTruck.ancestors

MyCar
VehicleRegister
Vehicle
Object
PP::ObjectMixin
Kernel
BasicObject
---
MyTruck
Vehicle
Object
PP::ObjectMixin
Kernel
BasicObject

5) Move all of the methods from the MyCar class that also pertain to the MyTruck class into the Vehicle class. Make sure that all of your previous method calls are working when you are finished.
def print_fuel_economy
    puts "This vehicle has a fuel economy of #{mileage / gas}"

    rescue
    puts "Invalid_info"
  end
  
6) Write a method called age that calls a private method to calculate the age of the vehicle. Make sure the private method is not available from outside of the class. You'll need to use Ruby's built-in Time class to help.

7) 
Given the following code...
bob = Person.new
bob.hi

And the corresponding error message...
NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
from (irb):8
from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'
'
Why and how to fix it?
`hi` is a private method so to fix, change to a public by moving its definition to before private keyword