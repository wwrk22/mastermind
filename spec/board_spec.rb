require_relative '../board.rb'

RSpec.describe Board do
subject(:board) { described_class.new }

  # Command method
  describe "#peg_code_holes" do
    context "when invalid row index is given" do
      it "raises an IndexError" do
        row_index = 99
        code_pegs = [
          Board::CodePeg::RED,
          Board::CodePeg::ORANGE,
          Board::CodePeg::YELLOW,
          Board::CodePeg::GREEN
        ]

        expect{ board.peg_code_holes(row_index, code_pegs) }
          .to raise_error(IndexError)
      end
    end

    context "when valid row index is given" do
      let(:row_index) { 0 }

      context "when four code pegs are given" do
        it "pegs all four holes in the given row" do
          code_pegs = [
            Board::CodePeg::RED,
            Board::CodePeg::ORANGE,
            Board::CodePeg::YELLOW,
            Board::CodePeg::GREEN
          ]
          board.peg_code_holes(row_index, code_pegs)
          
          board_code_holes = board.instance_variable_get(:@code_holes)
          expect(board_code_holes[row_index]).to eq(code_pegs)
        end
      end

      context "when an invalid number of code pegs are given" do
        context "when two code pegs are given" do
          it "raises an InvalidCodePegCountError" do
            code_pegs = [Board::CodePeg::RED, Board::CodePeg::ORANGE]
            error_msg = "An invalid count of #{code_pegs.size} code pegs were"\
                        " given. A row of code pegs must have a count of four."

            expect{ board.peg_code_holes(row_index, code_pegs) }
              .to raise_error(Board::InvalidCodePegCountError, error_msg)
          end
        end

        context "when five code pegs are given" do
          it "raises an InvalidCodePegCountError" do
            code_pegs = [
              Board::CodePeg::RED,
              Board::CodePeg::ORANGE,
              Board::CodePeg::YELLOW,
              Board::CodePeg::GREEN,
              Board::CodePeg::BLUE
            ]
            error_msg = "An invalid count of #{code_pegs.size} code pegs were"\
                        " given. A row of code pegs must have a count of four."

            expect{ board.peg_code_holes(row_index, code_pegs) }
              .to raise_error(Board::InvalidCodePegCountError, error_msg)
          end
        end
      end
    end
  end # #peg_code_holes

  describe "#peg_key_holes" do
    context "when invalid row index is given" do
      it "raises an IndexError" do
        row_index = 99
        key_pegs = [Board::KeyPeg::BLACK, Board::KeyPeg::WHITE]

        expect{ board.peg_key_holes(row_index, key_pegs) }
          .to raise_error(IndexError)
      end
    end

    context "when valid row index is given" do
      let(:row_index) { 0 }

      context "when an five key pegs are given" do
        it "raises a InvalidKeyPegCountError" do
          key_pegs = [
            Board::KeyPeg::BLACK,
            Board::KeyPeg::BLACK,
            Board::KeyPeg::BLACK,
            Board::KeyPeg::WHITE,
            Board::KeyPeg::WHITE
          ]
          error_msg = "An invalid count of #{key_pegs.size} key pegs were"\
                      " given. A row can have at most four key pegs."

          expect{ board.peg_key_holes(row_index, key_pegs) }
            .to raise_error(Board::InvalidKeyPegCountError, error_msg)
        end
      end

      context "when two key pegs are given" do
        it "correctly places the two key pegs" do
          key_pegs = [Board::KeyPeg::WHITE, Board::KeyPeg::BLACK]
          board.peg_key_holes(row_index, key_pegs)

          board_key_holes = board.instance_variable_get(:@key_holes)
          key_pegs_set = Set.new(key_pegs)
          expect(board_key_holes[0]).to eq(key_pegs_set)
        end
      end
    end
  end # #peg_key_holes

  describe "#clear" do
    it "clears all code peg holes and key peg holes" do
      board.clear
      board_code_holes = board.instance_variable_get(:@code_holes)
      board_key_holes = board.instance_variable_get(:@key_holes)
      empty_code_holes = Array.new(12) { Array.new }
      empty_key_holes = Array.new(12) { Set.new }
      expect(board_code_holes).to eq(empty_code_holes)
      expect(board_key_holes).to eq(empty_key_holes)
    end
  end # #clear_board
end # Board
