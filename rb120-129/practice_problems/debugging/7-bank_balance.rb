# Take this context below:
# zoom into these 2 lines


# success = (self.balance -= amount)

# if valid_transaction?(new_balance)

# We call self.balance.=(self.balance - amount)
# so what gets passed in as new_balance is self.balance - amount which is always going to be
# less than the balance.
# We should be checking if just the amount is >= .. ok nvm, I was on wrong track.

# maybe the short self.balance -= amount isnt actualizing as we expect?
# Nope that wasn''t it.

# Why does it seem like amount wasn''t actually withdrawn.

ooh i get it.
the `success` local variable is set to a boolean to determine if `amount` to withdraw is
greater than 0 when in actuality, we want to check if the `amount` substracted from `balance` is
greater than 0.
Otherwise success will message us saying ie 80 was withdrawn when we only had 50 - under the hood.
the transaction wasn''t valid and didn''t got through which is why @balance still unchaged at 50

^ uh nope you missed the point...there was actually 2 points of checking
even if amount > 0, success was going to be assigned to return value of
self.balance= which was intended to be either true or false depending on whether
balance - amount >= 0
The real issue is that regardless of what we explicity return with a setter, the setter method
returns the argument.

Further Exploration

What will the return value of a setter method be if you mutate its argument in the method body?
I''m guessing

after testing, if you mutate, the return value is the mutated object which shows the return
of the setter is the object id itself not the copy of the original object''s value.

# def withdraw(amount)
#     if amount > 0
#       success = (self.balance -= amount)
#     else
#       success = false
#     end

#     if success
#       "$#{amount} withdrawn. Total balance is $#{balance}."
#     else
#       "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
#     end
#   end

#   def balance=(new_balance)
#     if valid_transaction?(new_balance)
#       @balance = new_balance
#       true
#     else
#       false
#     end
#   end

#   def valid_transaction?(new_balance)
#     new_balance >= 0
#   end

class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    if amount >= 0 #ans key adds amount needs be greater than 0 too.
      puts self.balance=('a')
      puts "^ test"
    else
      success = false
    end

    if success
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def balance=(new_balance)
    new_balance.replace('b') if new_balance.class == String
    puts new_balance
    puts "^ other test"
    if valid_transaction?(new_balance)
      @balance = new_balance
      true
    else
      false
    end
  end

  def valid_transaction?(new_balance)
    new_balance == 0
  end
end

# Example

account = BankAccount.new('5538898', 'Genevieve')

                          # Expected output:
p account.balance         # => 0
p account.deposit(50)     # => $50 deposited. Total balance is $50.
p account.balance         # => 50
p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
                          # Actual output: $80 withdrawn. Total balance is $50.
p account.balance         # => 50