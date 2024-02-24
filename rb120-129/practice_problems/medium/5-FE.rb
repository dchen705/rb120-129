class EmptyStackError < StandardError; end

class InvalidTokenError < StandardError; end

class NoPrintError < StandardError; end

class Minilang
  VALID_TOKENS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(input)
    @register = 0
    @stack = []
    @commands = input
  end

  def eval(modifiers = nil)
    commands = modifiers.nil? ? @commands : format(@commands, modifiers)

    commands = commands.split.map do |command|
      if command =~ /\A[-+]?\d+\z/
        [:put, command.to_i]
      elsif VALID_TOKENS.include?(command)
        command.downcase.to_sym
      else
        command
      end
    end

    raise NoPrintError, '(nothing printed; no PRINT commands)' if commands.all?{ |command| command != :print }

    commands.each do |command|
      raise InvalidTokenError, "Invalid token: #{command}" if command.is_a?(String)
      send(*command)
    end
    rescue InvalidTokenError, EmptyStackError, NoPrintError => e
      puts e.message
  end

  private

  attr_accessor :register, :stack, :commands
  def print
    puts register
  end

  def put(n)
    self.register = n
  end

  def push
    stack << register
  end

  def mult
    self.register *= pop
  end

  def add
    self.register += pop
  end

  def pop
    raise EmptyStackError, 'Empty stack!' if stack.empty?
    self.register = stack.pop
  end

  def div
    self.register /= Integer(pop)
  end

  def mod
    self.register %= Integer(pop)
  end

  def sub
    self.register -= pop
  end
end

CENTIGRADE_TO_FAHRENHEIT =
'5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'

FAHRENHEIT_TO_CENTIGRADE =
'9 PUSH 5 PUSH 32 PUSH %<degrees_f>d SUB MULT DIV PRINT'

MPH_TO_KPH =
'5 PUSH 3 PUSH %<mph>d DIV MULT PRINT'

RECTANGLE_AREA =
'%<length>d PUSH %<width>d MULT PRINT'

# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 100)).eval
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: -40)).eval
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 0)).eval

# minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
# minilang.eval(degrees_c: 100)
# minilang.eval(degrees_c: 0)
# minilang.eval(degrees_c: -40)

# minilang = Minilang.new(FAHRENHEIT_TO_CENTIGRADE)
# minilang.eval(degrees_f: 212)
# minilang.eval(degrees_f: 32)
# minilang.eval(degrees_f: -40)

minilang = Minilang.new(MPH_TO_KPH)
minilang.eval(mph: 3)

minilang = Minilang.new(RECTANGLE_AREA)
minilang.eval(length: 5, width: 3)

# FE 2

# the way it's written, true, we might expect calling pop helper method from
# the arithmetic methods like mult, add, etc would cause the @register to change first
# as in #pop, @register = stack.pop...

# instead there's a placeholder that saves the current @register value and then
# the placeholder is operated on with the popped element and reassigned to @register.

# I'm thinking we call a method that just 'gets' the topmost element in the stack.
# then call pop. but that would require two methods for every artihmetic method.

# ie:
# oh wait, we can save

# I give up...looked at other peoples solution

# oh, ok, so some people converted the single purpose arithmetic operators into a case statement
# with send() and the aritmetic token.. bypassed the ambuguity and made code DRY.

# okay this is what I wanted to do that another student came up with

def top_value
  @register.last
end

def add
  new_value = @register + top_vaue
  pop
  @register = new_value
end