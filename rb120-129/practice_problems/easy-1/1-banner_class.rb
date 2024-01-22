# Complete this class so that the test cases shown below work as intended. You are free to add any methods or instance variables you need. However, do not make the implementation details public.

# You may assume that the input will always fit in your terminal window.

# class Banner
#   def initialize(message)
#     @message = message
#   end

#   def to_s
#     [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
#   end

#   private

#   def horizontal_rule
#     "+" + ("-" * (@message.size + 2)) + "+"
#   end

#   def empty_line
#     "|" + (" " * (@message.size + 2)) + "|"
#   end

#   def message_line
#     "| #{@message} |"
#   end
# end

# banner = Banner.new('To boldly go where no one has gone before.')
# puts banner
# # +--------------------------------------------+
# # |                                            |
# # | To boldly go where no one has gone before. |
# # |                                            |
# # +--------------------------------------------+

# banner = Banner.new('')
# puts banner
# # +--+
# # |  |
# # |  |
# # |  |
# # +--+

# # class Banner
# #   def initialize(message)
# #     @message = message
# #   end

# #   def to_s
# #     [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
# #   end

# #   private

# #   def horizontal_rule
# #     "+" + ("-" * (@message.size + 2)) + "+"
# #   end

# #   def empty_line
# #     "|" + (" " * (@message.size + 2)) + "|"
# #   end

# #   def message_line
# #     "| #{@message} |"
# #   end
# # end

# # banner = Banner.new('To boldly go where no one has gone before.')
# # puts banner
# # # +--------------------------------------------+
# # # |                                            |
# # # | To boldly go where no one has gone before. |
# # # |                                            |
# # # +--------------------------------------------+

# # banner = Banner.new('')
# # puts banner
# # +--+
# # |  |
# # |  |
# # |  |
# # +--+

# # Further Exploration

# # Modify this class so new will optionally let you specify a fixed banner width at the time the Banner object is created. The message in the banner should be centered within the banner of that width. Decide for yourself how you want to handle widths that are either too narrow or too wide.


class Banner
  MAX_WIDTH = 86
  MIN_WIDTH = 4
  def initialize(message, width = MAX_WIDTH)
    @message = message
    if width < MAX_WIDTH
      @width = width
    else
      @width = @message.size < MAX_WIDTH ? @message.size : MAX_WIDTH
    end
    @width = MIN_WIDTH if @width < MIN_WIDTH
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+" + ("-" * (@width - 2)) + "+"
  end

  def empty_line
    "|" + (" " * (@width - 2)) + "|"
  end

  def message_line
    message_lines = []
    loop do
      message = @message.slice!(0, @width - 4)
      message_lines << "|" + message.center(@width - 2) + "|"
      break if @message.size == 0
    end
    message_lines
  end
end

banner = Banner.new('To boldly go where no one has gone before.To boldly go where no one has gone before.To boldly go where no one has gone before.To boldly go where no one has gone before.', 20)
puts banner

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
banner = Banner.new('')
puts banner
banner = Banner.new('To boldly go where no one has gone before.', 30)
puts banner