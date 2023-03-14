require_relative '../player'


class Computer < Player
  attr_accessor :last_guess

  def initialize
    super("Computron")
    reset_guess_pool
  end

  ##
  # Return a random guess from the guess pool. The guess is deleted from the
  # pool before the method returns.
  def random_guess
    guess_index = rand(@guess_pool.size)
    guess = @guess_pool[guess_index]
    @guess_pool.delete_at(guess_index)
    return guess
  end

  ##
  # Make a random guess based on the key code given. In a pool of all possible
  # possible guesses, eliminate those that would not give the given key code,
  # then return a random guess out of the updated pool of guesses.
  def educated_guess(key_code)

  end

  ##
  # Clear the guess pool, then fill it with all 1296 guesses.
  def reset_guess_pool
    @guess_pool = []
    fill_guess_pool
  end

  private

  ##
  # Generate every guess permutation and add it to the pool.
  def fill_guess_pool
    0.upto(5) do |code_peg_0|
      0.upto(5) do |code_peg_1|
        0.upto(5) do |code_peg_2|
          0.upto(5) do |code_peg_3|
            @guess_pool.push([code_peg_0, code_peg_1, code_peg_2, code_peg_3])
          end
        end
      end
    end
  end

end
