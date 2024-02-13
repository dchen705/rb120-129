high level description > initial custom object organizations (nouns/verbs) >
high level procedural steps for orchestral engine >
helper methods low level

Game has 2 participants: Player and Dealer, a deck which has 52 cards.

Game lets player turn then lets dealer turn then decides winner.

In a participant''s turn, Participants can do: hit or stay

Hit means to draw a card.
Each card has a value ranging from 2-9, A, J, Q, K and a suit from 4 and a revealed status.
2-10 are face value
JQK are 10
A is 1 or 11 depending on Hand value

After each hit, the Game checks for a bust which is an immediate losing condition
based on the total value of Hand surpassing 21.

Stay means to not draw and end participants turn. If both players stay and neither busted, then Game decides winner


nouns: Game, Player, Dealer, Deck, Card, Value, Hand
verbs: hit, stay

Game has Player, Dealer, Deck
Deck has 52 Card
Player and Dealer has Hand
Player and Dealer collaborate with Deck (via Game?)
Card has value and suit and reveal_status
    - Card with value ace needs to collaborate
Hand has value... wait actually

*Note the difference between a card''s value and its rank
EDIT
Card has a rank, suit and reveal_status
Hand has a value, has a set of Card objects

Player and Dealer can do: hit or stay
Game can do: let player_turn, dealer_turn, decide_winner

Player and Dealer inherit from Participant

What I forgot:
- both participants intially dealt 2 cards
- Dealer''s requirement to stay is when his Hand reaches at least 17
- winner is decided by whoever is higher in value (assuming neither busted)

Game collaborates with Player and Dealer - dealing cards

Perhaps Hand is not a class, it''s a set of Card held by each Participant

similar to lesson but they suggest `deal` belongs to Dealer or Deck, not the Game like I was thinking...
also why do they use Hand as a module?

hmm..does deck belong as a class itself?