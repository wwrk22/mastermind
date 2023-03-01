module Errors
  ##
  # Require 4 code pegs to be given when filling the holes of a row on the
  # board.
  class NotEnoughCodePegsError < StandardError
    def initialize(num_code_pegs)
      @num_code_pegs = num_code_pegs
    end

    def message
      "Not enough code pegs. Only #{@num_code_pegs} were given but 4 code pegs"\
      " are required."
    end
  end
end
