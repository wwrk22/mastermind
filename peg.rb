module Peg
  ROW_MAX_PEG_COUNT = 4

  module CodePeg
    # The six colors that a code peg can have.
    RED = 1
    ORANGE = 2
    YELLOW = 3
    GREEN = 4
    BLUE = 5
    PURPLE = 6
  end

  module KeyPeg
    # Black = indicate a code peg with the right color and position
    # White = indicate a code peg with the right color but a wrong position
    BLACK = 1
    WHITE = 2
  end
end
