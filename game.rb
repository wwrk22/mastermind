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
end
