require 'test_helper'

class RudokuTest < Test::Unit::TestCase
  context "a board" do
    setup do
      str = File.read(BASE_FOLDER + "/examples/0.txt")
      @board = Rudoku::Board.from_string(str)
    end
    should "load propperly" do
      assert @board
    end

    should 'be solvable' do
      @board.pre_solve
      @board.solve
      assert @board.solved?
    end
  end
end
