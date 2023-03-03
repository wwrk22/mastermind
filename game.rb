class Game

  def initialize
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


  private

  def generate_secret_code
    [rand(6), rand(6), rand(6), rand(6)]
  end

  def check_guess(code_pegs)
    return code_pegs == @secret_code
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
