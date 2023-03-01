require_relative '../board.rb'

RSpec.describe Board do
  # Command method
  describe "#peg_code_holes" do
    subject(:board) { described_class.new }

    context "when invalid row index is given" do
      it "raises an IndexError" do
        row_index = 99
        colors = [Board::RED, Board::ORANGE, Board::YELLOW, Board::GREEN]

        expect{ board.peg_code_holes(row_index, colors) }
          .to raise_error(IndexError)
      end
    end

    context "when valid row index is given" do
      let(:row_index) { 0 }

      context "when four code pegs are given" do
        it "pegs all four holes in the given row" do
          colors = [Board::RED, Board::ORANGE, Board::YELLOW, Board::GREEN]
          board.peg_code_holes(row_index, colors)
          
          board_code_holes = board.instance_variable_get(:@code_holes)
          expect(board_code_holes[row_index]).to eq(colors)
        end
      end

      context "when less than four code pegs are given" do
        it "raises a NotEnoughCodePegsError" do
          colors = [Board::RED, Board::ORANGE]

          expect{ board.peg_code_holes(row_index, colors) }
            .to raise_error(Board::NotEnoughCodePegsError)
        end
      end
    end
  end
end
