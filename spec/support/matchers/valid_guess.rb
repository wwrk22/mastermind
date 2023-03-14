module ValidGuess
  class ValidGuess
    def matches?(guess)
      @guess = guess

      @guess.each do |code_peg|
        if code_peg < 0 || 5 < code_peg
          return false
        end
      end

      return true
    end

    def failure_message
      "#{@guess} is invalid. It has at least one code peg with value outside of the bounds of [0,5]."
    end
  end

  def be_valid_guess
    ValidGuess.new
  end
end
