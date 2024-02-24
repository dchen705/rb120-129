class EmptyStackError < StandardError; end

class InvalidTokenError < StandardError; end

class NoPrintError < StandardError; end

class Minilang
  VALID_TOKENS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(input)
    @register = 0
    @stack = []
    @commands = input.split.map do |command|
      if command =~ /\A[-+]?\d+\z/
        [:put, command.to_i]
      elsif VALID_TOKENS.include?(command)
        command.downcase.to_sym
      else
        command
      end
    end
  end

  def eval
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
    self.register *= stack.pop
  end

  def add
    self.register += stack.pop
  end

  def pop
    raise EmptyStackError, 'Empty stack!' if stack.empty?
    self.register = stack.pop
  end

  def div
    self.register /= Integer(stack.pop)
  end

  def mod
    self.register %= Integer(stack.pop)
  end

  def sub
    self.register -= stack.pop
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)