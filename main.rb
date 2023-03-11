require_relative './game'


human = Player.new("Human")
computer = Player.new("Computer")
game = Game.new(human, computer)
game.play
