require_relative '../game.rb'
require 'support/game_spec_helper'


RSpec.describe Game do
  include GameSpecHelper

  # Suppress stdout and stderr messages on console.
  before :all do
    @stdout = $stdout
    @stderr = $stderr
    $stdout = File.open(File::NULL, 'w')
    $stderr = File.open(File::NULL, 'w')
  end

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

    before do
      allow(game).to receive(:display_round_results)
    end

    context "when player has at least one more guess left for the round" do
      it "does not display round results" do
        game.end_of_guess_check
        expect(game).not_to have_received(:display_round_results)
      end
    end

    context "when player has no guesses left for the round" do
      before do
        game.instance_variable_set(:@board_row_index, Board::NUM_ROWS - 1)
      end

      it "displays round results" do
        game.end_of_guess_check
        expect(game).to have_received(:display_round_results)
      end

    end
  end # #end_of_guess_check


  describe "#prompt_round_count" do
    subject(:game) { described_class.new(Board.new, nil, nil) }
    let(:error_message) { "Number of rounds must be within two and ten inclusive." }
    let(:valid_input) { "2" }
    let(:invalid_input) { "foo" }

    before do
      allow(game).to receive(:puts).with(error_message)
    end

    context "when user input is valid" do
      before do
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it "stops loop and does not display the error message" do
        game.prompt_round_count
        expect(game).not_to have_received(:puts).with(error_message)
      end
    end

    context "when user gives one invalid input then a valid one" do
      before do
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it "displays the error message once, then stops the loop" do
        game.prompt_round_count
        expect(game).to have_received(:puts).with(error_message).once
      end
    end
  end

  after :all do
    $stdout = @stdout
    $stderr = @stderr
    @stdout = nil
    @stderr = nil
  end
end
