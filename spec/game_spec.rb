require_relative '../game.rb'


RSpec.describe Game do

  describe "#generate_and_set_secret_code" do

    let(:board) { instance_double(Board) }
    subject(:game) { described_class.new(board, nil, nil) }

    it "sets a valid secret code in the game board" do 
      expect(board).to receive(:secret_code=)
      game.generate_and_set_secret_code
    end

  end

end
