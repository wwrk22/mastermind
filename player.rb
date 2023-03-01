class Player
  attr_accessor :score
  attr_accessor :name

  def initialize(name)
    @name = name
    @score = 0
  end
end
