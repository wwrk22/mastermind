require_relative './board.rb'

class Game
  
  def initialize(board, player_1, player_2, num_rounds=1)
    @board = board
    @players = [player_1, player_2]
    @board_row_idx = 0
    @num_rounds = num_rounds
  end

  ##
  # Create an array of four randomly generated integers within [0, 5] to
  # represent a row of code pegs and set it in the board as the secret
  # code.
  def generate_and_set_secret_code
    secret_code = [rand(6), rand(6), rand(6), rand(6)]
    @board.secret_code = secret_code
  end


  ##
  # Prompt player for a guess then return an array containing the four numbers of
  # the guess. Return nil if the guess is invalid.
  def prompt_guess
    guess = gets.chomp
    
    if guess_valid? guess
      guess_array = []

      guess.each_char do |c|
        guess_array.append(c.to_i)
      end

      return guess_array
    else
      return nil
    end
  end


  ##
  # Return true if the given guess matches the secret code on the game board.
  # Otherwise, return false.
  def check_guess(guess)
    return guess == @board.secret_code
  end


  ##
  # Return an array of correctly generated key pegs for the given code pegs.
  def generate_key_pegs(code_pegs)
    key_pegs = []

    code_pegs.each_with_index do |code_peg, index|
      if code_peg == @board.secret_code[index]
        key_pegs.append(Board::KeyPeg::BLACK)
      elsif @board.secret_code.include? code_peg
        key_pegs.append(Board::KeyPeg::WHITE)
      end
    end

    key_pegs
  end


  private

  ##
  # Check to make sure each digit (code peg) in the guess is a valid one.
  # Integer ordinals of '0', '1', ..., '5' are 48 to 53. Return true if
  # all digits are valid. Otherwise, return false.
  def guess_valid?(guess)
    if guess.length == 4
      valid_range = Array(48..53)
      
      guess.each_char do |c|
        if valid_range.include?(c.ord) == false
          return false
        end
      end

      return true
    else
      return false
    end
  end
end
