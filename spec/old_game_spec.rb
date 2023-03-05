require_relative '../game.rb'

RSpec.describe Game do
  subject(:game) { described_class.new }

  describe "#prompt_guess" do
    context "when guess does not have length of four" do
      before do
        invalid_guess = "01"
        allow(game).to receive(:gets).and_return(invalid_guess)
      end

      it "returns nil" do
        guess = game.prompt_guess
        expect(guess).to be_nil
      end
    end

    context "when guess has at least one non-integer char" do
      before do
        invalid_guess = "12ab"
        allow(game).to receive(:gets).and_return(invalid_guess)
      end

      it "returns nil" do
        guess = game.prompt_guess
        expect(guess).to be_nil
      end
    end

    context "when guess is four digits" do
      context "when one digit is not within [0, 5]" do
        before do
          invalid_guess = "1127"
          allow(game).to receive(:gets).and_return(invalid_guess)
        end

        it "returns nil" do
          guess = game.prompt_guess
          expect(guess).to be_nil
        end
      end

      context "when all four digits are within [0, 5]" do
        let(:valid_guess) { "1122" }

        before do
          allow(game).to receive(:gets).and_return(valid_guess)
        end

        it "returns the guess as an array of the four digits" do
          valid_guess_array = []

          valid_guess.each_char do |c|
            valid_guess_array.append(c.to_i)
          end

          guess = game.prompt_guess
          expect(guess).to eq(valid_guess_array)
        end
      end
    end
  end # #prompt_guess

  describe "#prompt_and_peg_guess" do
    let(:current_board_row) { game.instance_variable_get(:@current_board_row) }
    let(:board) { instance_double(Board) }
    let(:valid_guess) { [0, 1, 2, 3] }

    before do
      game.instance_variable_set(:@board, board)
    end

    context "when a valid guess is given on the first prompt" do

      before do
        allow(game).to receive(:prompt_guess).and_return(valid_guess)
      end

      it "pegs the user guess in the current board row" do
        expect(board).to receive(:peg_code_holes).with(current_board_row, valid_guess)
        game.prompt_and_peg_guess
      end
    end

    context "when a valid guess is given on the second prompt" do
      before do
        invalid_guess = nil
        allow(game).to receive(:prompt_guess).and_return(invalid_guess, valid_guess)
      end

      it "pegs the user guess in the current board row" do
        expect(board).to receive(:peg_code_holes).with(current_board_row, valid_guess)
        game.prompt_and_peg_guess
      end
    end
  end # #prompt_and_peg_guess

  describe "#check_guess" do
    context "when guess is correct" do
      it "returns true" do
        secret_code = game.instance_variable_get(:@secret_code)
        
        result = game.check_guess(secret_code)
        expect(result).to eq(true)
      end
    end

    context "when guess is incorrect" do
      it "returns false after placing key pegs in the current row" do
        secret_code = [0, 1, 2, 3]
        wrong_code = [0, 1, 2, 4]
        game.instance_variable_set(:@secret_code, secret_code)

        result = game.check_guess(wrong_code)
        expect(result).to eq(false)
      end
    end
  end # #check_guess

  describe "#generate_key_pegs" do
    it "generates an order-agnostic array of key pegs for a given row of code pegs" do
      secret_code = [
        Board::CodePeg::RED,
        Board::CodePeg::ORANGE,
        Board::CodePeg::YELLOW,
        Board::CodePeg::GREEN
      ]
      guess = [
        Board::CodePeg::RED,
        Board::CodePeg::BLUE,
        Board::CodePeg::BLUE,
        Board::CodePeg::ORANGE
      ]
      expected_key_pegs = [Board::KeyPeg::BLACK, Board::KeyPeg::WHITE]
      game.instance_variable_set(:@secret_code, secret_code)

      generated_key_pegs = game.generate_key_pegs(guess)
      expect(generated_key_pegs).to eq(expected_key_pegs)
    end
  end # #generate_key_pegs

  describe "#play_guess" do
    let(:board) { instance_double(Board) }
    let(:current_board_row) { game.instance_variable_get(:@current_board_row) }
    let(:secret_code) { game.instance_variable_get(:@secret_code) }

    before do
      game.instance_variable_set(:@board, board)
    end

    context "when guess is correct" do
      before do
        allow(board).to receive(:get_code_peg_row).with(current_board_row).and_return(secret_code)
      end

      it "sets game over to true" do
        game.play_guess

        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to eq(true)
      end
    end

    context "when guess is incorrect" do
      before do
        wrong_code = secret_code.map { |code| (code * 2) % 6 }
        allow(board).to receive(:get_code_peg_row).with(current_board_row).and_return(wrong_code)
      end

      it "sets game over to false" do
        game.play_guess

        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to eq(false)
      end
    end
  end # #play_guess

  describe "#play_turn" do
    context "when at least one guess is left" do
      expect(game).to receive(:play_guess)
    end

    context "when no guesses are left" do

    end
  end
end
