class Student
  def initialize(name = 'nil', year = 'nil')
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student
  def initialize(name, year) # deletable
    super
  end
end

class Placeholder < Student
  def initialize
    super()
  end
end

# Other students
# one of most liked had the same idea
# the most liked decided to use super() in Student which inherits from StudentBody

class StudentBody
  @@total_students = 0

  def initialize
    @@total_students += 1
    @student_number = @@total_students
  end
end

class Student < StudentBody
  def initialize(name, year)
    @name = name
    @year = year
    super()                     # Here is where `super()` is invoked.
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student
  def initialize(name, year)
    super
  end
end