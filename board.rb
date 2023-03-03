require 'Set'
require './peg.rb'
require './board_errors.rb'


class Board
  include Peg
  include Errors

  NUM_ROWS = 12

  attr_reader :secret_code

  def initialize
    @code_rows = create_new_row
    @key_rows = create_new_row
  end

  ##
  # Peg the given code_pegs in the row at index row_index.
  # Raises an IndexError if the given row_index is not within the bounds of
  # [0, 11].
  # Raises an InvalidCodePegCountError if exactly four pegs are not given.
  def peg_code_holes(row_index, code_pegs)
    # Validate row index.
    @code_rows.fetch(row_index)

    # Disallow empty code peg holes or more than four.
    if code_pegs.size != ROW_MAX_PEG_COUNT
      raise InvalidCodePegCountError.new(code_pegs.size)
    end

    # Each code peg is represented by its color.
    # e.g. CodePeg::RED
    code_pegs.each do |peg|
      @code_rows[row_index].append(peg)
    end
  end

  ##
  # Peg the given key_pegs in the row at index row_index.
  # Raises an IndexError if the given row_index is not within the bounds of
  # [0, 11].
  # Raises an InvalidKeyPegCountError if more than four key pegs are given.
  def peg_key_holes(row_index, key_pegs)
    # Validate row index.
    @key_rows.fetch(row_index)

    # Disallow key peg count greater than four.
    if key_pegs.size > ROW_MAX_PEG_COUNT
      raise InvalidKeyPegCountError.new(key_pegs.size)
    end

    # Each key peg is represented by its color.
    # e.g. KeyPeg::BLACK
    key_pegs.each do |peg|
      @key_rows[row_index].append(peg)
    end
  end

  ##
  # Return the code peg row at the given index.
  # Raise an IndexError if the index is not within the bounds of [0, 11].
  def get_code_peg_row(row_index)
    @code_rows.fetch(row_index)
  end

  ##
  # Return the key peg row at the given index.
  # Raise an IndexError if the index is not within the bounds of [0, 11].
  def get_key_peg_row(row_index)
    @key_rows.fetch(row_index)
  end

  ##
  # Clear all rows of code pegs and key pegs.
  def clear
    @code_rows = create_new_row
    @key_rows = create_new_row
  end

  ##
  # Print the board to stdout.
  def display
    full_rows = @code_rows.zip(@key_rows)

    full_rows.each do |row|
      code_pegs = row[0]
      key_pegs = row[1]

      code_pegs.each { |code_peg| print "#{code_peg} " }
      print "| "
      key_pegs.each { |key_peg| print "#{key_peg} " }
      print "\n"
    end
  end

  ##
  # Set the secret code. The secret_code arg must be an Array of size 4.
  # Raise a TypeError if secret_code is not an Array.
  # Raise an InvalidCodePegCountError if secret_code does not have four colors.
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

  def create_new_row
    Array.new(NUM_ROWS) { Array.new }
  end
end
