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
end
