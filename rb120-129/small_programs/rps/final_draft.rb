# UX and OOP Design

# UX requirements/desired features:

Display "Welcome to RPS "
Please select an opponent


My Vision

  2 game modes
  - Classic Mode
  - Boss Rush Mode
    - player has limited number of tries and has to clear 3 opponents
    - to beat each cpu, player has to win 3x in a row
    - here are modes:
      - 1st move random, rest of moves will be mimicking player''s last move
      - randomize order the 5 moves, then cycle through the same order (too easy?)
      - randomize order 5 moves, loop w/ a new random order each loop
      
      - randomize a sequence (random length between 2-5), cycle through it (mayb replace w/ 2nd option)
      Mimic
      Cycler
      Random Cycler
      Other ideas: Unbeatable or Unlosable
      
      I want to try and incorporate polymorphism... that is I want to be able to
      create an interface that lets me easily insert different AI types and have the gameplay
      customize depending on the AI insertion. We can even have a roster of AI and have the gameplay
      select a lineup of 3 random AI from the roster.
  
  User friendly graphic interface
    - need a guide interface that shows what beats what 


BIG PICTURE

                      OOP Framework + Procedural Flow
                      in context of 2 modes
                      old stuff: procedures
                      new stuff: relationships + groupings of objects
                      /                           \
                GUI                             AI polymorphism of Boss Rush Mode Gamplay
              user friendliness                         not just AI, but modes can be polymorphic
              static GUI 
              (scores, what beats what)

`play` not called as RPSGame.play but rather RPSGame.mode.play
RPSGame has a Mode
alternative is RPSGame.play(mode) but I''d rather separate the modes into diff class than keep in
RPSGame.

Probe Coding Plan 
50 - AI overall, 2.5 - AI logic, 1.5 - overall structuing 


