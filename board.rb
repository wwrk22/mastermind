require 'Set'
require './peg'
require './board_errors'


class Board
  include Peg
  include Errors

  NUM_ROWS = 12
  ROW_MAX_PEG_COUNT = 4

  attr_reader :secret_code

  def initialize(secret_code = nil)
    @secret_code = secret_code
    @code_rows = create_new_rows
    @key_rows = create_new_rows
  end

  ##
  # Place the given code_pegs in the row at index row_index.
  # Raises an IndexError if the given row_index is not within the bounds of
  # [0, 11].
  # Raises an InvalidCodePegCountError if exactly four pegs are not given.
  def place_code_pegs(row_index, code_pegs)
    @code_rows.fetch(row_index)

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
  # Place the given key_pegs in the row at index row_index.
  # Raises an IndexError if the given row_index is not within the bounds of
  # [0, 11].
  # Raises an InvalidKeyPegCountError if more than four key pegs are given.
  def place_key_pegs(row_index, key_pegs)
    @key_rows.fetch(row_index)

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
  # Return the code pegs at the given index.
  # Raises an IndexError if `row_index` is not within bounds [0, 11].
  def get_code_pegs(row_index)
    @code_rows.fetch(row_index)
  end


  ##
  # Clear all rows of code pegs and key pegs.
  def clear
    @code_rows = create_new_rows
    @key_rows = create_new_rows
  end

  ##
  # Print the board to stdout.
  def display
    full_rows = @code_rows.zip(@key_rows)

    full_rows.each do |row|
      print_code_pegs(row[0])
      print_key_pegs(row[1]) 
    end
  end

  ##
  # Set the secret code. The secret_code arg must be an Array of size 4.
  # Raise a TypeError if secret_code is not an Array.
  # Raise an InvalidCodePegCountError if secret_code does not have four colors.
  def secret_code=(secret_code)
    if secret_code.class != Array
      raise TypeError, "Expected an Array. Got #{secret_code.class}."
    end

    if secret_code.size != 4
      raise InvalidCodePegCountError.new(secret_code.size)
    end

    @secret_code = secret_code
  end

  private

  def print_code_pegs(code_pegs)
    if code_pegs.size == 0
      print "        "
    else
      code_pegs.each { |code_peg| print "#{code_peg} " }
    end

    print "| " # divide the board
  end


  def print_key_pegs(key_pegs)
    key_pegs.each { |key_peg| print "#{key_peg} " }
    print "\n"
  end


  def create_new_rows
    Array.new(NUM_ROWS) { Array.new }
  end
end
