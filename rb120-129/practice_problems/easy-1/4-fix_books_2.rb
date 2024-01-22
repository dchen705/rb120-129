# Complete this program so that it produces the expected output:

class Book
  attr_accessor :author, :title
  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# The author of "Snow Crash" is Neil Stephenson.
# book = "Snow Crash", by Neil Stephenson.

Further Exploration

What do you think of this way of creating and initializing Book objects? (The two steps are separate.) Would it be better to create and initialize at the same time like in the previous exercise? What potential problems, if any, are introduced by separating the steps?


I think either way, the user has to input correct values to set the states whether in the former example during initialization as parameters or as in this example having to call two different setters.
I think an advantage of the previous approach is we set the states during initilization which means unlike this example, there''s less risk of instantating a new object and forgetting to set its values which can lead to problems later. I guess, at one point both approaches will signal an error, the former example just signals sooner in the process.

Other students similar vein:
- more risk to nil errors in this example if one forgets to set
- we have to unncessarily expose setters in this example (which is a disadvantage I missed)