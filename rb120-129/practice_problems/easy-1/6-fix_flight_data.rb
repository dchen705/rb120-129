# There is nothing technically incorrect about this class, but the definition may lead to problems in the future. How can this class be fixed to be resistant to future problems?

class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# We are exposing the getter and setter methods for @database_handle which appears to be assigned to a database possibly containing sensitive information that we don't want to give users easy access to mutate or reassign the instance variable itself to diff object. To fix this, we can privatize the `attr_accessor.`


class Flight

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
  private
  attr_accessor :database_handle
end

ANS KEY says to just delete the attr_accessor