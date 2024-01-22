# Complete this program so that it produces the expected output:

class Book
  attr_reader :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# The author of "Snow Crash" is Neil Stephenson.
# book = "Snow Crash", by Neil Stephenson.

# Further exploration

# all three are accessor methods, attr_reader creates a getter for an instance variable specified in argument, attr_writer creates a setter, and attr_accessor creates both. 
# we used #attr_reader because this program only requires getter functionality for @title and @author. Though attr_accessor would also work because it also creates a getter method.

def title
  @title
end

def author
  @author
end

# ^ Code also runs if we replaced attr_reader with these manual
# getter methods. An advangate of manual getters is we have greater control to manipulate and format the instance variable value before being returned.

# OTHER student explanation also good
attr_reader makes a getter method, attr_writer makes a setter method, and attr_accessor makes both. We generally want to only create public methods for things we actually need to use outside of the class (in this case, we only need a getter to accomplish the task). The code would still work with a setter, but it's unnecessary and can cause potential issues down the line if the setter is used by accident.