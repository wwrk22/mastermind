require_relative '../player'


class Computer < Player
  attr_accessor :last_guess

  def initialize
    super("Computron")
    @guess_pool = create_guess_pool
  end


  def random_guess
    return [rand(6), rand(6), rand(6), rand(6)]
  end


  ##
  # Make a random guess based on the key code given. In a pool of all possible
  # possible guesses, eliminate those that would not give the given key code,
  # then return a random guess out of the updated pool of guesses.
  def educated_guess(key_code)

  end

  def create_guess_pool
    guess_pool = []
    generate_all_guesses(guess_pool)
    return guess_pool
  end

  private

  def generate_all_guesses(guess_pool)
    0.upto(5) do |code_peg_0|
      0.upto(5) do |code_peg_1|
        0.upto(5) do |code_peg_2|
          0.upto(5) do |code_peg_3|
            guess_pool.push([code_peg_0, code_peg_1, code_peg_2, code_peg_3])
          end
        end
      end
    end
  end

end
