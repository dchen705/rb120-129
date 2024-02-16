class AuthenticationError < Exception; end

# A mock search engine
# that returns a random number instead of an actual count.
# the return value of `score` in all three cases is
# DoesItRock::NoScore
# ^ only when we make the API key not match

Below is the fixed code. Retrospectively, instead of raising the AuthenticationError, instead
within the case statement, `score` was assigned to DoesItRock::NoScore so I replaced the return
value of that rescue clause with the raised error exception which I captured with local var `e`

Ans key: 
Now, back to the original problem: if the API key is wrong, we want the AuthenticationError to reach the find_out method. One way to achieve this is to simply remove the rescue clause in Score::for_term. But this would also prevent us from rescuing other exceptions, like a possible ZeroDivisionError, which arguably is a perfect occasion to return no score. In order to solve this, we decide to rescue only that specific exception within Score::for_term and let all others through.
Ok, so another way to let the error through to the #find_out method even if its raised in the
#for_term method is to disclude the rescue in for_term which will let it into the #find_out method.

class SearchEngine
  def self.count(query, api_key)
    unless valid?(api_key)
      raise AuthenticationError, 'API key is not valid.'
    end

    rand(200_000)
  end

  private

  def self.valid?(key)
    key == 'LS1A'
  end
end

module DoesItRock
  API_KEY = 'LS1B'

  class NoScore; end

  class Score
    def self.for_term(term)
      positive = SearchEngine.count(%{"#{term} rocks"}, API_KEY)
      negative = SearchEngine.count(%{"#{term} is not fun"}, API_KEY)

      (positive * 100) / (positive + negative)
    rescue Exception => e
      raise e
    end
  end

  def self.find_out(term)
    score = Score.for_term(term)

    case score
    when NoScore
      "No idea about #{term}..."
    when 0...40
      "#{term} is not fun."
    when 40...60
      "#{term} seems to be ok..."
    else
      "#{term} rocks!"
    end
  rescue Exception => e
    e.message
  end
end

# Example (your output may differ)

puts DoesItRock.find_out('Sushi')       # Sushi seems to be ok...
puts DoesItRock.find_out('Rain')        # Rain is not fun.
puts DoesItRock.find_out('Bug hunting') # Bug hunting rocks!