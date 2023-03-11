require_relative './game'
require_relative './player'


board = Board.new
human = Player.new("Human")
computer = Player.new("Computer")
game = Game.new(board, human, computer)
game.play
