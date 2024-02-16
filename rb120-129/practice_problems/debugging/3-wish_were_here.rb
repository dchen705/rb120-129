# Expecting true comes down likely to misunderstanding how puts works...the puts call will output
# the to_s method return value on the puts argument. This is fine for when we do puts grace.location, etc...
# because grace.location erturns a GeoLocation object which is converted to a string by to_s.
# But in the last line, before puts converts either grace.location or ace.location to a string, a method
# called #== is actually called we could rewrite it like so:
# ade.location.=(grace.location) therefore a boolean gets returned by this equality method check before
# we even get to use to_s from puts

# To fix this, we can create a custom #== method:

class Person
  attr_reader :name
  attr_accessor :location

  def initialize(name)
    @name = name
  end

  def teleport_to(latitude, longitude)
    @location = GeoLocation.new(latitude, longitude)
  end
end

class GeoLocation
  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def to_s
    "(#{latitude}, #{longitude})"
  end

  def ==(other_location)
    self.to_s == other_location.to_s
  end
end

# Example

ada = Person.new('Ada')
ada.location = GeoLocation.new(53.477, -2.236)

grace = Person.new('Grace')
grace.location = GeoLocation.new(-33.89, 151.277)

ada.teleport_to(-33.89, 151.277)

puts ada.location                   # (-33.89, 151.277)
puts grace.location                 # (-33.89, 151.277)
puts ada.location == grace.location # expected: true
                                    # actual: false