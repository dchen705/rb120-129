class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

class Square < Rectangle
  def initialize(side)
    @height = side
    @width = side
  end
end

# Write a class called Square that inherits from Rectangle, and is used like this:

square = Square.new(5)
puts "area of square = #{square.area}"

ANS KEY - USED `super`

class Square < Rectangle
  def initialize(length_of_side)
    super(length_of_side, length_of_side)
  end
end