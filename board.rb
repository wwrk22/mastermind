require './code_peg.rb'
require './board_errors.rb'


class Board
  include CodePeg
  include Errors

  def initialize
    @code_holes = Array.new(12) { Array.new(4) }
    @peg_holes = Array.new(12) { Set.new }
  end

  def peg_code_holes(row_index, code_pegs)
    # Validate row index before moving on.
    @code_holes.fetch(row_index)

    # Disallow empty code peg holes or more than four.
    if code_pegs.size != ROW_SIZE
      raise NotEnoughCodePegsError.new(code_pegs.size)
    end

    # Each code peg is represented by its color.
    # e.g. CodePeg::RED
    code_pegs.each_with_index do |color, col_index|
      @code_holes[row_index][col_index] = color
    end
  end
end
