class Game
  
  def initialize(board, player_1, player_2, num_rounds=1)
    @board = board
    @players = [player_1, player_2]
    @board_row_idx = 0
    @num_rounds = num_rounds
  end

end
