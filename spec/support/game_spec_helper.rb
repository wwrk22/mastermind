require_relative '../../peg'

module GameSpecHelper
  include Peg

  SAMPLES = [ 
    { # 0
      secret_code: [
        CodePeg::RED,
        CodePeg::ORANGE,
        CodePeg::YELLOW,
        CodePeg::GREEN
      ],
      guess: [
        CodePeg::RED,
        CodePeg::GREEN,
        CodePeg::BLUE,
        CodePeg::BLUE
      ],
      key_pegs: [
        KeyPeg::BLACK,
        KeyPeg::WHITE
      ]
    },
    { # 1
      secret_code: [
        CodePeg::RED,
        CodePeg::RED,
        CodePeg::BLUE,
        CodePeg::BLUE
      ],
      guess: [
        CodePeg::RED,
        CodePeg::RED,
        CodePeg::RED,
        CodePeg::YELLOW
      ],
      key_pegs: [
        KeyPeg::BLACK,
        KeyPeg::BLACK
      ]
    }
  ]
end
