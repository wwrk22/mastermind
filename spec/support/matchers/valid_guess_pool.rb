module ValidGuessPool
  GUESS_POOL_SIZE = 1296

  class ValidGuessPool
    def matches?(guess_pool)
      @guess_pool = guess_pool
      return false if @guess_pool.size != GUESS_POOL_SIZE
      return false if check_uniq == false
      return true
    end

    def failure_message
      error_message = "Guess pool does not meet requirements."
      error_message += size_error_message
      error_message += duplicate_error_message
    end


    private

    def check_uniq
      return true if @guess_pool.uniq.size == @guess_pool.size

      @duplicates_exist = true
      return false
    end

    def size_error_message
      if @guess_pool.size != GUESS_POOL_SIZE
        return "\nGuess pool should have #{GUESS_POOL_SIZE} guesses,"\
               " but it has #{@guess_pool.size} guesses."
      end

      return ""
    end

    def duplicate_error_message
      return "\nGuess pool should not have any duplicate guesses." if @duplicates_exist
      return ""
    end
  end

  def be_valid_guess_pool
    ValidGuessPool.new
  end
end
