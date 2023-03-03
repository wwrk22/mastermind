module Peg
  ROW_MAX_PEG_COUNT = 4

  module CodePeg
    # The six colors that a code peg can have.
    RED = 0
    ORANGE = 1
    YELLOW = 2
    GREEN = 3
    BLUE = 4
    PURPLE = 5
  end

  module KeyPeg
    # Black = indicate a code peg with the right color and position
    # White = indicate a code peg with the right color but a wrong position
    BLACK = 0
    WHITE = 1
  end
end
