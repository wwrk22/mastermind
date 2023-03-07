require_relative '../game.rb'
require 'support/game_spec_helper'


RSpec.describe Game do
  include GameSpecHelper

  describe "#generate_and_set_secret_code" do
    let(:board) { instance_double(Board) }
    subject(:game) { described_class.new(board, nil, nil) }

    it "sets a valid secret code in the game board" do 
      expect(board).to receive(:secret_code=)
      game.generate_and_set_secret_code
    end
  end # #generate_and_set_secret_code


  describe "#prompt_guess" do
    subject(:game) { described_class.new(Board.new, nil, nil) }

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


  describe "#generate_key_pegs" do 
    let(:board) { Board.new }
    subject(:game) { described_class.new(board, nil, nil) }

    GameSpecHelper::SAMPLES.each do |sample|
      it "generates an order-agnostic array of key pegs for a given row of code pegs" do
        board.secret_code = sample[:secret_code]
        generated_key_pegs = game.generate_key_pegs(sample[:guess])
        expect(generated_key_pegs).to eq(sample[:key_pegs])
      end
    end
  end # #generate_key_pegs


  describe "#end_of_guess_check" do
    subject(:game) { described_class.new(Board.new, nil, nil) }

    context "when player has at least one more guess left for the round" do
      it "does not display round results" do
        expect(game).not_to receive(:display_round_results)
        game.end_of_guess_check
      end
    end

    context "when player has no guesses left for the round" do
      before do
        game.instance_variable_set(:@board_row_index, Board::NUM_ROWS - 1)
      end

      it "displays round results" do
        expect(game).to receive(:display_round_results)
        game.end_of_guess_check
      end

    end
  end # #end_of_guess_check

end
