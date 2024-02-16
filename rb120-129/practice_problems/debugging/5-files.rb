# The issue is because when we call to_s (from the puts call) on an instance of File, the constant lookup path
# starts at the lexical scope up to but discluding the top scope, then checks all super classes then checks
# the top scope... constants aren''t checked in a subclass of the class that references the constant.

# To fix...we need to place the Constants in the lookup path.
# - one way is having to_s for each subclass File so lookup starts in subclass
# - another way is using polymorphism through shared instance method name, ie: giving
# all subclass - a format method

# Ans key pointed out two other great ideas:
# - using instance var to represent the file format (but doesn''t convey format is immalable by using var)
# - class.self::Format -> wow that''s clever. this way no matter what, class.self is a polymorphic
# term



class File
  attr_accessor :name, :byte_content

  def initialize(name)
    @name = name
  end

  alias_method :read,  :byte_content
  alias_method :write, :byte_content=

  def copy(target_file_name)
    target_file = self.class.new(target_file_name)
    target_file.write(read)

    target_file
  end

  def to_s
    "#{name}.#{format_type}"
  end

  def format_type
    # ...
  end
end

class MarkdownFile < File
  FORMAT = :md
end

class VectorGraphicsFile < File
  FORMAT = :svg
end

class MP3File < File
  FORMAT = :mp3
end

# Test

blog_post = MarkdownFile.new('Adventures_in_OOP_Land')
blog_post.write('Content will be added soon!'.bytes)

copy_of_blog_post = blog_post.copy('Same_Adventures_in_OOP_Land')

puts copy_of_blog_post.is_a? MarkdownFile     # true
puts copy_of_blog_post.read == blog_post.read # true

puts blog_post