require_relative '../board.rb'

RSpec.describe Board do
subject(:board) { described_class.new }
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
          
          board_code_rows = board.instance_variable_get(:@code_rows)
          expect(board_code_rows[row_index]).to eq(code_pegs)
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

          board_key_rows = board.instance_variable_get(:@key_rows)
          expect(board_key_rows[0]).to eq(key_pegs)
        end
      end
    end
  end # #peg_key_holes

  describe "#clear" do
    it "clears all code peg holes and key peg holes" do
      board.clear
      board_code_rows = board.instance_variable_get(:@code_rows)
      board_key_rows = board.instance_variable_get(:@key_rows)
      empty_code_rows = Array.new(Board::NUM_ROWS) { Array.new }
      empty_key_rows = Array.new(Board::NUM_ROWS) { Array.new }
      expect(board_code_rows).to eq(empty_code_rows)
      expect(board_key_rows).to eq(empty_key_rows)
    end
  end # #clear_board

  describe "#set_secret_code" do
    context "when correct type is used for secret_code" do
      context "when four code pegs are given" do
        it "sets the secret code" do
          secret_code = [
            Board::CodePeg::RED,
            Board::CodePeg::ORANGE,
            Board::CodePeg::YELLOW,
            Board::CodePeg::GREEN
          ]
          board.set_secret_code(secret_code)

          board_secret_code = board.instance_variable_get(:@secret_code)
          expect(board_secret_code).to eq(secret_code)
        end
      end

      context "when two code pegs are given" do
        it "raises a InvalidCodePegCountError" do
          secret_code = [Board::CodePeg::RED, Board::CodePeg::ORANGE]
          
          error_msg = "An invalid count of #{secret_code.size} code pegs were"\
                      " given. A row of code pegs must have a count of four."
          expect{ board.set_secret_code(secret_code) }
            .to raise_error(Board::InvalidCodePegCountError, error_msg)
        end
      end
    end

    context "when wrong class type is used for secret_code" do
      it "raises a TypeError" do
        secret_code = "RED, ORANGE, YELLOW, GREEN"

        error_msg = "Expected an Array. Got #{secret_code.class}."
        expect{ board.set_secret_code(secret_code) }
          .to raise_error(TypeError, error_msg)
      end
    end
  end # #set_secret_code

  describe "#display_board" do
    
  end

end # Board
