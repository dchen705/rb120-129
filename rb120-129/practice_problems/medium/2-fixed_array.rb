# I manually raised IndexErrors.. to solve the prob but I don''t think the way to solve was elegant.\

class FixedArray
  attr_accessor :values

  def initialize(length)
    @values = Array.new(length)
  end

  def [](index)
    length = values.size
    raise IndexError if !(-length..(length - 1)).to_a.include?(index)
    values[index]
  end

  def []=(index, new_value)
    length = values.size
    raise IndexError if !(-length..(length - 1)).to_a.include?(index)
    values[index] = new_value
  end

  def to_a
    values
  end

  def to_s
    values.to_s
  end
end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end

oooh yeah, I forgot about #fetch..
# also cloning the #to_a return value seems good idea too if we plan to mutate - don't want
to affect the OG instance state.
Ans key:
class FixedArray
  def initialize(max_size)
    @array = Array.new(max_size)
  end

  def [](index)
    @array.fetch(index)
  end

  def []=(index, value)
    self[index]             # raise error if index is invalid!
    @array[index] = value
  end

  def to_a
    @array.clone
  end

  def to_s
    to_a.to_s
  end
end