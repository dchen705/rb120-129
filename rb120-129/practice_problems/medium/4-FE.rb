# my intuition is telling me to make @buffer a Buffer class that inherits from Array so I can
# use its push and shift methods...wait I don't think I need to inherit..

class CircularBuffer
  attr_accessor :buffer
  attr_reader :max_size

  def initialize(number_of_positions)
    @buffer = []
    @max_size = number_of_positions
  end

  def put(object)
    buffer.shift if buffer.size >= max_size
    buffer.push(object)
  end

  def get
    buffer.shift
  end
end

buffer = CircularBuffer.new(3)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

buffer = CircularBuffer.new(4)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 4
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil