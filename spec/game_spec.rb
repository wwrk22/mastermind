require_relative '../game'
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
    subject(:game) { described_class.new(nil, nil) }

    it "sets a valid secret code in the game board" do 
      board = game.instance_variable_get(:@board)
      expect(board).to receive(:secret_code=)
      game.generate_and_set_secret_code
    end
  end # #generate_and_set_secret_code


  # Looping Script Method
  describe "#prompt_guess" do
    subject(:game) { described_class.new(nil, nil) }
    let(:error_message) { "Invalid input. Guess must be four digits with every digit within [0,5]." }
    let(:valid_input) { "0123" }
    let(:invalid_input) { "01ww" }

    before do
      allow(game).to receive(:puts).with(error_message)
    end

    context "when user input is valid" do
      before do
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it "does not display the error message and immediately stops loop" do
        game.prompt_guess
        expect(game).not_to have_received(:puts).with(error_message)
      end
    end

    context "when user gives an invalid input, then a valid input" do
      before do
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it "displays the error message once then stops loop" do
        game.prompt_guess
        expect(game).to have_received(:puts).with(error_message).once
      end
    end

  end # #prompt_guess


  describe "#generate_key_pegs" do 
    subject(:game) { described_class.new(nil, nil) }

    GameSpecHelper::SAMPLES.each do |sample|
      it "generates an order-agnostic array of key pegs for a given row of code pegs" do
        board = game.instance_variable_get(:@board)
        board.secret_code = sample[:secret_code]

        generated_key_pegs = game.generate_key_pegs(sample[:guess])
        expect(generated_key_pegs).to eq(sample[:key_pegs])
      end
    end
  end # #generate_key_pegs


  describe "#end_of_guess_check" do
    subject(:game) { described_class.new(nil, nil) }

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
    subject(:game) { described_class.new(nil, nil) }
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


  describe "#guess_valid?" do
    subject(:game) { described_class.new(nil, nil) }

    context "when guess is valid" do
      it "returns true" do
        valid_guess = "0123"

        result = game.guess_valid? valid_guess
        expect(result).to eq(true)
      end
    end

    context "when guess is invalid" do
      it "returns false" do
        invalid_guess = "01ab"

        result = game.guess_valid?(invalid_guess)
        expect(result).to eq(false)
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
