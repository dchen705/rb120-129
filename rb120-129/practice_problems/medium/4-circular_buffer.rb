# there's two approaches I'm thinking: one way is to do some kinda positioning that cycles
# another way, I could just tag each object with its place (this way seems easier)
# hm actually the cicular positioning better mimics the behavior of putting when full..

# class CircularBuffer
#   attr_accessor :oldest, :buffer

#   def initialize(number_of_positions)
#     @buffer = Array.new(number_of_positions)
#   end

#   def put(value)
#     if buffer_empty?
#       buffer[0] = value
#       self.oldest = 0
#     else
#       buffer[oldest] = value
#     end
#   end

#   def get
#     if buffer_empty?
#       nil
#     else
#       oldest_value = buffer[oldest]
#       buffer[oldest] = nil
#       adjust_oldest
#       oldest_value
#     end
#   end

#   def buffer_empty?
#     buffer.all?(&:nil?)
#   end

#   def buffer_full?
#     !buffer.any?(&:nil?)
#   end

#   def adjust_oldest
#     self.oldest += 1
#     self.oldest = 0 if oldest >= buffer.size - 1
#   end
# end

# buffer = CircularBuffer.new(3)
# puts buffer.get == nil

# buffer.put(1)
# buffer.put(2)
# puts buffer.get == 1

# CircularBuffer States:
# @oldest

# I remember something... circular loop. We can use modulus likely...
# 0 1 2 3 4 5
# 0/3 1/3 2/3 3/3 4/3 5/3
# 0 1 2 0 1 2


# CircularBuffer#add
# - emptybuffer? add to 0
# - find the next position to add recursively
#   or using a conditional loop like (+1 until value at position is nil)
#   loop back to position 0 after index = size - 1 (using modulus)
# - full_buffer?
#   - replace oldest buffer
#   - change oldest to oldest += 1
#     - helper method: cycle

# class CircularBuffer
#   attr_accessor :buffer, :oldest

#   def initialize(number_of_positions)
#     @buffer = Array.new(number_of_positions)
#   end

#   def put(value)
#     if buffer_empty?
#       buffer[0] = value
#       self.oldest = 0
#     elsif buffer_full?
#       buffer[oldest] = value
#       self.oldest = next_position(oldest)
#     else
#       offset = next_empty_offset
#       buffer[next_position(oldest + offset)] = value
#     end
#   end

#   def buffer_empty?
#     buffer.all?(&:nil?)
#   end

#   def buffer_full?
#     !buffer.any?(&:nil?)
#   end

#   def next_position(index)
#     (index + 1) % buffer.size
#   end

#   def next_empty_offset
#     offset = 0
#     loop do
#       return offset if buffer[next_position(oldest + offset)].nil?
#       offset += 1
#     end
#   end
# end

# buffer = CircularBuffer.new(3)

# buffer.put(1)
# buffer.put(2)
# buffer.put(3)
# p buffer.buffer #[1, 2, 3]
# buffer.put(4)
# buffer.put(5)
# p buffer.buffer #[4, 5, 3]

# I realized for a circular buffer, it's not a requirement for, in case of empty buffer,
# for the starting object inserted in to start at position 0. just as long as the oldest
# gets removed relative to the current one being inserted in.
# I was worrying about including a feature that wasn't necessary which why it was
# a little extra complicated in my head.

class CircularBuffer
  attr_accessor :buffer, :oldest, :next_position

  def initialize(number_of_positions)
    @buffer = Array.new(number_of_positions)
    @oldest = 0
    @next_position = 0
  end

  def put(object)
    unless buffer[next_position].nil?
      self.oldest = shift_position(oldest)
    end
    buffer[next_position] = object
    self.next_position = shift_position(next_position)
  end

  def get
    object = buffer[oldest]
    self.buffer[oldest] = nil
    self.oldest = shift_position(oldest) unless object.nil?
    object
  end

  def shift_position(index)
    (index + 1) % buffer.size
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