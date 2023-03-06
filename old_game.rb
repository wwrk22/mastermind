require_relative './board.rb'

class Game

  def initialize
    @board = Board.new
    @current_board_row = 0
    @secret_code = generate_secret_code
  end


  def prompt_and_peg_guess
    guess = prompt_guess until guess.kind_of? Array
    @board.peg_code_holes(@current_board_row, guess)
  end


  def play_guess
    guess = @board.get_code_peg_row(@current_board_row)
    @game_over = check_guess(guess)
  end

  private

  def generate_secret_code
    [rand(6), rand(6), rand(6), rand(6)]
  end
  
end
