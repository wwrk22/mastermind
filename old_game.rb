require_relative './board.rb'

class Game

  def initialize
    @board = Board.new
    @current_board_row = 0
    @secret_code = generate_secret_code
  end

  ##
  # Return an array of the four digits in the user's guess.
  # Return nil if invalid guess was given.
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

  def prompt_and_peg_guess
    guess = prompt_guess until guess.kind_of? Array
    @board.peg_code_holes(@current_board_row, guess)
  end

  def check_guess(code_pegs)
    return code_pegs == @secret_code
  end

  def generate_key_pegs(code_pegs)
    key_pegs = []

    code_pegs.each_with_index do |code_peg, index|
      if code_peg == @secret_code[index]
        key_pegs.append(Board::KeyPeg::BLACK)
      elsif @secret_code.include? code_peg
        key_pegs.append(Board::KeyPeg::WHITE)
      end
    end

    key_pegs
  end

  def play_guess
    guess = @board.get_code_peg_row(@current_board_row)
    @game_over = check_guess(guess)
  end

  private

  def generate_secret_code
    [rand(6), rand(6), rand(6), rand(6)]
  end
  
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
