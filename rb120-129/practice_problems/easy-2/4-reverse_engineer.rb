expected OUTPUT
ABC
xyz

COMMANDS
my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')

class Transform
  attr_reader :value
  def initialize(value='')
    @value = value
  end
  
  def uppercase
    value.upcase
  end
  
  def self.lowercase(value)
    value.downcase
  end
end

for some reason, my mind did not immediately recognize Transform.lowercase() as a class method call
  
Other student, hm,didn''t think to inherit from String
class Transform < String
  def uppercase
    self.upcase
  end

  def self.lowercase(input)
    input.downcase
  end
end