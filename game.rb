require_relative './board'
require_relative './player'

class Game

  MIN_ROUND_COUNT = 2
  MAX_ROUND_COUNT = 10
  
  def initialize(player_1, player_2)
    @board = Board.new
    @players = [player_1, player_2]
    @board_row_index = 0
    @round_num = 1
    @code_broken = false
  end


  ##
  # Play the desired number of rounds.
  # Generates and sets a secret code, and prompts the player for the number of
  # rounds to play.
  def play
    setup_game

    until @round_num > @round_count do
      @board.clear
      play_round
      display_round_results
      @round_num += 1
    end

    puts "GAME OVER"
  end


  ##
  # Create an array of four randomly generated integers within [0, 5] to
  # represent a row of code pegs and set it in the board as the secret
  # code.
  def generate_and_set_secret_code
    secret_code = [rand(6), rand(6), rand(6), rand(6)]
    @board.secret_code = secret_code
  end


  def prompt_guess
    loop do
      print "Make a guess: "
      guess = gets.chomp

      if guess_valid? guess
        return make_guess_array(guess)
      else
        puts "Invalid input. Guess must be four digits with every digit within [0,5]."
      end
    end
  end


  ##
  # Takes a `guess` string that represents four code pegs, and returns an array
  # of those code pegs in integer format.
  def make_guess_array(guess)
    return guess.each_char.map { |c| c.to_i }
  end


  ##
  # Prompt player for number of rounds to be played until valid input is given.
  # The number must be within two and ten, inclusive.
  def prompt_round_count
    loop do
      print "How many rounds will there be? "
      round_count = gets.chomp.to_i

      if MIN_ROUND_COUNT <= round_count && round_count <= MAX_ROUND_COUNT
        return round_count
      else
        puts "Number of rounds must be within two and ten inclusive."
      end
    end
  end


  ##
  # Return true if the given guess matches the secret code on the game board.
  # Otherwise, return false.
  def check_guess(guess)
    return guess == @board.secret_code
  end


  ##
  # Return an array of correctly generated key pegs for the given code pegs.
  def check_code_pegs(code_pegs)
    # Keep track of code pegs that haven't been matched yet.
    not_yet_matched = Array.new(@board.secret_code)
    key_pegs = []

    code_pegs.each_with_index do |code_peg, index|
      key_peg = generate_key_peg(code_peg, index, not_yet_matched)
      key_pegs.append(key_peg) if key_peg
    end

    return key_pegs
  end


  ##
  # Check to make sure each digit (code peg) in the guess is a valid one.
  # Integer ordinals of '0', '1', ..., '5' are 48 to 53. Return true if
  # all digits are valid. Otherwise, return false.
  def guess_valid?(guess)
    return false if guess.length != Board::ROW_MAX_PEG_COUNT

    guess.each_char do |c|
      if Board::CodePeg::ORDINALS.include?(c.ord) == false
        return false
      end
    end

    return true
  end


  private

  def end_of_guess_update
    @board_row_index = (@board_row_index + 1) % Board::NUM_ROWS
    if @board_row_index == 0
      puts "No more guesses are left this round."
      puts "The secret code was #{@board.secret_code}"
    end
  end

  def process_guess
    puts "Wrong guess."
    guess = @board.get_code_pegs(@board_row_index)
    key_pegs = check_code_pegs(guess)
    @board.place_key_pegs(@board_row_index, key_pegs)
  end

  ##
  # Return the correct key peg for the given code peg.
  # Return nil if neither key peg is appropriate.
  def generate_key_peg(code_peg, index, not_yet_matched)
    if code_peg == @board.secret_code[index]
      not_yet_matched.delete(code_peg)
      return Board::KeyPeg::BLACK
    else
      found_index = not_yet_matched.find_index(code_peg)

      if found_index
        not_yet_matched.delete_at(found_index)
        return Board::KeyPeg::WHITE
      else
        return nil
      end
    end
  end

  ##
  # Play the current round until the player breaks the secret code or runs out
  # of guesses.
  def play_round
    puts ">> ROUND #{@round_num} <<"
    @board_row_index = 0

    until @board_row_index < Board::NUM_ROWS do
      guessed_correctly = play_guess
      @board.display

      if guessed_correctly
        puts "Congratulations. You broke the secret code #{@board.secret_code}."
        break
      else
        process_guess
      end

      end_of_guess_update
    end
  end

  ##
  # Prompt a guess and place the code pegs for it on the board.
  # Then check the guess to either end the current round or place the key pegs
  # for a wrong guess. A guess always awards one point to the code maker.
  def play_guess
    @players[1].score += 1

    guess = prompt_guess 
    @board.place_code_pegs(@board_row_index, guess)
    return true if check_guess(guess)
    return false
  end


  ##
  # Print intro message, generate and set the board's secret code, then prompt
  # player for number of rounds to play.
  # Set score to zero for both players.
  def setup_game
    puts "Welcome to Mastermind."
    generate_and_set_secret_code
    @round_count = prompt_round_count
    @players[0].score = 0
    @players[1].score = 0
  end




  ##
  # Print the results of the current round to stdout.
  def display_round_results
    human = @players[0]
    computer = @players[1]

    puts "End of round #{@round_num}"
    puts "#{human.name} has #{human.score} points"
    puts "#{computer.name} has #{computer.score} points"
  end
end
