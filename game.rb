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
      generate_and_set_secret_code
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
  # Return an array of the appropriate key pegs in the current row for the
  # given guess. Return an empty array when none of the code pegs in the
  # guess are used in the secret code
  def check_guess(guess)
    key_code = []
    secret_code_pegs_left = []
    guess_code_pegs_left = []
    black_key_pegs = in_pos_code_pegs(guess, secret_code_pegs_left, guess_code_pegs_left)
    key_code.push(*black_key_pegs)
    white_key_pegs = out_of_pos_code_pegs(secret_code_pegs_left, guess_code_pegs_left)
    key_code.push(*white_key_pegs)
    return key_code
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

  ##
  # Process secret code pegs that weren't matched in its position to return
  # an array of white key pegs that indicate existing matches in the guess
  # code pegs given.
  def out_of_pos_code_pegs(secret_code_pegs_left, guess_code_pegs_left)
    key_pegs = []

    secret_code_pegs_left.each do |code_peg|
      found_index = guess_code_pegs_left.find_index code_peg
      if found_index
        guess_code_pegs_left.delete_at(found_index)
        key_pegs.push(Board::KeyPeg::WHITE)
      end
    end

    return key_pegs
  end

  ##
  # Process a guess and return an array of black key pegs for all code pegs
  # that are in the correct position according to the board's secret code.
  def in_pos_code_pegs(guess, secret_code_pegs_left, guess_code_pegs_left)
    black_key_pegs = []

    @board.secret_code.each_with_index.map do |code_peg, index|
      if code_peg == guess[index]
        black_key_pegs.push(Board::KeyPeg::BLACK)
      else
        secret_code_pegs_left.push(code_peg)
        guess_code_pegs_left.push(guess[index])
      end
    end

    return black_key_pegs
  end


  def end_of_guess_update
    @board_row_index += 1

    if @board_row_index == Board::NUM_ROWS
      puts "No more guesses are left this round."
      puts "The secret code was #{@board.secret_code}"
    end
  end

  def process_guess
    puts "Wrong guess."
    guess = @board.get_code_pegs(@board_row_index)
    key_pegs = check_guess(guess)
    @board.place_key_pegs(@board_row_index, key_pegs)
  end


  ##
  # Play the current round until the player breaks the secret code or runs out
  # of guesses.
  def play_round
    puts ">> ROUND #{@round_num} <<"
    @board_row_index = 0

    while @board_row_index < Board::NUM_ROWS do
      guessed_correctly = play_guess

      if guessed_correctly
        puts "Congratulations. You broke the secret code #{@board.secret_code}."
        break
      else
        process_guess
      end

      @board.display
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
    return true if guess == @board.secret_code
    return false
  end


  ##
  # Print intro message, generate and set the board's secret code, then prompt
  # player for number of rounds to play.
  # Set score to zero for both players.
  def setup_game
    puts "Welcome to Mastermind."
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
