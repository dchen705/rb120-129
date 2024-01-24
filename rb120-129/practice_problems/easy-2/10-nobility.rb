module Walkable
  def walk
    "#{full_name} #{gait} forward"
  end
end

class Noble
  attr_reader :name, :title
  
  include Walkable
  def initialize(name, title)
    @name = name
    @title = title
  end
  
  private
  
  def gait
    "struts"
  end
  
  def full_name
    title + " " + name
  end
end

byron = Noble.new("Byron", "Lord")
p byron.walk
# => "Lord Byron struts forward"

p byron.name
# => "Byron"
p byron.title
# => "Lord"

ANS KEY:
module Walkable
  def walk
    "#{self} #{gait} forward"
  end
end

So, this is exactly what we do. We define #to_s in all 4 classes, returning just the name in 3 classes, and returning both the title and name in the Noble class. Finally, we tell Walkable#walk to use #to_s to obtain the person's name (or name and title).

Wait just one minute. How are we doing that? There's no mention of #to_s in Walkable#walk, is there? Actually, there is - it's just hidden. When you perform interpolation on some value in a string, ruby automatically calls #to_s for you. So, #{self} in the string is actually #{self.to_s} in disguise. In the case of a Cat object, this calls Cat#to_s, but in the case of a Noble, it calls Noble#to_s.

Further Exploration

This exercise can be solved in a similar manner by using inheritance; a Noble is a Person, and a Cheetah is a Cat, and both Persons and Cats are Animals. What changes would you need to make to this program to establish these relationships and eliminate the two duplicated #to_s methods?

Is to_s the best way to provide the name and title functionality we needed for this exercise? Might it be better to create either a different name method (or say a new full_name method) that automatically accesses @title and @name? There are tradeoffs with each choice -- they are worth considering.

Make Animal > (Person > Noble), (Cat > Cheetah )
Have #to_s as name only and include Walkable mmodule in Person and Cat
But for Noble, over to_s with title and name

module Walkable
  def walk
    "#{self} #{gait} forward"
  end
end

class Animal
  attr_reader :name

  include Walkable

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end
end

class Person < Animal
  private
  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :title
  def initialize(name, title)
    @name = name
    @title = title
  end
  private
  def gait
    "struts"
  end
  def to_s
    title + " " + name
  end
end

class Cat < Animal
  private
  def gait
    "saunters"
  end
end

class Cheetah < Cat
  private
  def gait
    "runs"
  end
end

Comparing my first attempt: using a full_name method vs self as in answer key...
I think using self has more disadvantages. For one, you are repurposing an important method
#to_s for primary purpose of one method, `walk`, if we require calling self for something else, we'd have to change implementation
another issue is that using full_name method is more explicit than taking advantage of 
string interpolation calling to_s which makes it potentially easier to read.

Other student
another solution I kinda considered:
I just wasn''t sure if @title would throw an error in cases of non-Noble classes
module Walkable
  def walk
    @title == nil ?  "#{self.name} #{gait} forwards" :  "#{@title} #{self.name} #{gait} forwards"
  end
end

this seems doable though
module Walkable
  def walk
    subject = self.class == Noble ? name + ' ' + title : name
    p "#{subject} #{self.gait} forward"
  end
end

^ as some mentioned, weakness of configing the module, if we introduce another exception other 
than Noble, we have to change the "interface" each time.

wtf kinda clever:
He uses super in def walk to refer to the module def walk. ain''t seen that stuff before.

module Walkable
  def walk(title='')
    "#{title} #{name} #{gait} forward".lstrip
  end
end

class Noble < Person
  include Walkable

  attr_reader :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def walk
    super(title)
  end

  def gait
    "struts"
  end
end