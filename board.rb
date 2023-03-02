require './peg.rb'
require './board_errors.rb'


class Board
  include Peg
  include Errors

  def initialize
    @code_holes = Array.new(12) { Array.new(4) }
    @key_holes = Array.new(12) { Set.new }
  end

  def peg_code_holes(row_index, code_pegs)
    # Validate row index before moving on.
    @code_holes.fetch(row_index)

    # Disallow empty code peg holes or more than four.
    if code_pegs.size != ROW_MAX_PEG_COUNT
      raise InvalidCodePegCountError.new(code_pegs.size)
    end

    # Each code peg is represented by its color.
    # e.g. CodePeg::RED
    code_pegs.each_with_index do |peg, col_index|
      @code_holes[row_index][col_index] = peg
    end
  end

  def peg_key_holes(row_index, key_pegs)
    # Validate row index before moving on.
    @key_holes.fetch(row_index)

    # Disallow key peg count greater than four.
    if key_pegs.size > ROW_MAX_PEG_COUNT
      raise InvalidKeyPegCountError.new(key_pegs.size)
    end

    # Each key peg is represented by its color.
    # e.g. KeyPeg::BLACK
    key_pegs.each do |peg|
      @key_holes[row_index].add(peg)
    end
  end
end
