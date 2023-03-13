require_relative '../../peg'

module GameSpecHelper
  include Peg::CodePeg
  include Peg::KeyPeg

  SECRET_CODES = [ 
    [RED, RED, RED, RED],         # 0
    [ORANGE, RED, RED, RED],      # 1
    [ORANGE, ORANGE, RED, RED],   # 2
    [RED, ORANGE, YELLOW, GREEN], # 3
    [RED, ORANGE, YELLOW, YELLOW] # 4
  ]

  GUESSES = [
    [ # 0
      [ORANGE, ORANGE, ORANGE, ORANGE], # a
      [RED, ORANGE, ORANGE, ORANGE],    # b
      [RED, RED, ORANGE, ORANGE],       # c
      [RED, RED, RED, ORANGE],          # d
      [RED, RED, RED, RED]              # e
    ],
    [ # 1
      [ORANGE, ORANGE, YELLOW, YELLOW], # a
      [YELLOW, ORANGE, ORANGE, YELLOW], # b
      [ORANGE, RED, ORANGE, ORANGE],    # c
      [RED, ORANGE, ORANGE, YELLOW]      # d
    ],
    [ # 2
      [ORANGE, ORANGE, ORANGE, YELLOW], # a
      [ORANGE, YELLOW, ORANGE, ORANGE], # b
      [ORANGE, ORANGE, RED, ORANGE],    # c
      [RED, RED, ORANGE, ORANGE]        # d
    ],
    [ # 3
      [RED, RED, YELLOW, GREEN],    # a
      [BLUE, RED, RED, BLUE],       # b
      [YELLOW, RED, ORANGE, YELLOW] # c
    ],
    [ # 4
      [GREEN, YELLOW, YELLOW, YELLOW], # a
      [YELLOW, YELLOW, GREEN, YELLOW], # b
      [YELLOW, YELLOW, RED, RED]       # c
    ]
  ]

  KEY_CODES = [
    [ # 0
      [],                           # a
      [BLACK],                      # b
      [BLACK, BLACK],               # c
      [BLACK, BLACK, BLACK],        # d
      [BLACK, BLACK, BLACK, BLACK]  # e
    ],
    [ # 1
      [BLACK],        # a
      [WHITE],        # b
      [BLACK, BLACK], # c
      [WHITE, WHITE]  # d
    ],
    [ # 2
      [BLACK, BLACK],              # a
      [BLACK, WHITE],              # b
      [BLACK, BLACK, BLACK],       # c
      [WHITE, WHITE, WHITE, WHITE] # d
    ],
    [ # 3
      [BLACK, BLACK, BLACK], # a
      [WHITE],               # b
      [WHITE, WHITE, WHITE]  # c
    ],
    [ # 4
      [BLACK, BLACK],       # a
      [BLACK, WHITE],       # b
      [WHITE, WHITE, WHITE] # c
    ]
  ]

end
