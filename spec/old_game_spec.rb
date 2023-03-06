require_relative '../game.rb'

RSpec.describe Game do
  subject(:game) { described_class.new }


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
