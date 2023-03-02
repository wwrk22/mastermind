module Errors
  ##
  # Require 4 code pegs to be given when filling the holes of a row on the
  # board.
  class InvalidCodePegCountError < StandardError
    def initialize(num_code_pegs)
      @num_code_pegs = num_code_pegs
    end

    def message
      "An invalid count of #{@num_code_pegs} code pegs were"\
      " given. A row of code pegs must have a count of four."
    end
  end

  ##
  # Allow at most 4 key pegs for a row.
  class InvalidKeyPegCountError < StandardError
    def initialize(num_key_pegs)
      @num_key_pegs = num_key_pegs
    end

    def message 
      "An invalid count of #{@num_key_pegs} key pegs were"\
      " given. A row can have at most four key pegs."
    end
  end
end
