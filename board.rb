require_relative 'piece'

class Board
  BOARD_SIZE = 8
  WHITE_ROWS_TO_SETUP = [0,1,2]
  BLACK_ROWS_TO_SETUP = [5,6,7]

  attr_reader :board

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    setup_board
  end

  def [](pos)
    x, y = pos
    board[x][y]
  end

  def []=(pos, value)
    x, y = pos
    board[x][y] = value
  end

  def setup_board
    setup_white
    setup_black
  end

  def setup_white
    rows.each_with_index do |row, idx|
      if idx.even? && WHITE_ROWS_TO_SETUP.include?(idx)
        row.each_with_index do |square, jdx|
          Piece.new([idx, jdx], self, :white) if jdx.even?
        end
      elsif WHITE_ROWS_TO_SETUP.include?(idx)
        row.each_with_index do |square, jdx|
          Piece.new([idx, jdx], self, :white) if jdx.odd?
        end
      end
    end
  end

  def setup_black

    rows.each_with_index do |row, idx|
      if idx.odd? && BLACK_ROWS_TO_SETUP.include?(idx)
        row.each_with_index do |square, jdx|
          Piece.new([idx, jdx], self, :black) if jdx.odd?
        end
      elsif BLACK_ROWS_TO_SETUP.include?(idx)
        row.each_with_index do |square, jdx|
          Piece.new([idx, jdx], self, :black) if jdx.even?
        end
      end
    end
  end

  def render
    board.each do |row|
      rendered_row = row.map { |square| square.nil? ? "[ ]" : "[#{square}]" }
      puts rendered_row.join("")
    end
    nil
  end

  private

  def rows
    board
  end

end
