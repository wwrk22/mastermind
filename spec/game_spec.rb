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


  describe "#check_guess" do 
    subject(:game) { described_class.new(nil, nil) }

    it "generates the correct order-agnostic key code for any given guess" do
      result = true
      board = game.instance_variable_get(:@board)

      GameSpecHelper::SECRET_CODES.each_with_index do |secret_code, i|
        board.secret_code = secret_code
        guesses = GameSpecHelper::GUESSES[i]
        key_codes = GameSpecHelper::KEY_CODES[i]

        guesses.each_with_index do |guess, j|
          key_code = game.check_guess(guess)
          result = false if key_code != key_codes[j]
          # BEGIN DEBUG
          if key_code != key_codes[j]
            puts "TEST FAILED FOR\nSECRET CODE #{secret_code}\nGUESS #{guess}\nKEY CODE #{key_codes[j]}\nGENERATED KEY CODE #{key_code}\n"
          end
          # END DEBUG
        end
      end

      expect(result).to eq(true)
    end
  end # #check_guess


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
