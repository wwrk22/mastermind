require 'Set'
require './peg.rb'
require './board_errors.rb'


class Board
  include Peg
  include Errors

  NUM_ROWS = 12

  attr_reader :secret_code

  def initialize
    @code_holes = create_new_code_holes
    @key_holes = create_new_key_holes
  end

  ##
  # Peg the given code_pegs in the row at index row_index.
  # Raises an IndexError if the given row_index is not within the bounds of
  # [0, 11].
  # Raises an InvalidCodePegCountError if exactly four pegs are not given.
  def peg_code_holes(row_index, code_pegs)
    # Validate row index.
    @code_holes.fetch(row_index)

    # Disallow empty code peg holes or more than four.
    if code_pegs.size != ROW_MAX_PEG_COUNT
      raise InvalidCodePegCountError.new(code_pegs.size)
    end

    # Each code peg is represented by its color.
    # e.g. CodePeg::RED
    code_pegs.each do |peg|
      @code_holes[row_index].append(peg)
    end
  end

  ##
  # Peg the given key_pegs in the row at index row_index.
  # Raises an IndexError if the given row_index is not within the bounds of
  # [0, 11].
  # Raises an InvalidKeyPegCountError if more than four key pegs are given.
  def peg_key_holes(row_index, key_pegs)
    # Validate row index.
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

  ##
  # Return the code peg row at the given index.
  # Raise an IndexError if the index is not within the bounds of [0, 11].
  def get_code_peg_row(row_index)
    # Validate row index.
    @code_holes.fetch(row_index)
  end

  def clear
    @code_holes = create_new_code_holes
    @key_holes = create_new_key_holes
  end

  ##
  # Set the secret code. The secret_code arg must be an Array of size 4.
  # Raise an <error-here> if secret_code is not an Array.
  # Raise an <error-here> if secret_code does not have four colors.
  def set_secret_code(secret_code)
    # Validate type and size.
    if secret_code.class != Array
      raise TypeError, "Expected an Array. Got #{secret_code.class}."
    end

    if secret_code.size != 4
      raise InvalidCodePegCountError.new(secret_code.size)
    end

    @secret_code = secret_code
  end

  private

  def create_new_code_holes
    Array.new(NUM_ROWS) { Array.new }
  end

  def create_new_key_holes
    Array.new(NUM_ROWS) { Set.new }
  end
end
