require_relative '../player'


class Computer < Player
  attr_accessor :last_guess

  def initialize
    super("Computron")
  end


  def random_guess
    return [rand(6), rand(6), rand(6), rand(6)]
  end

end
