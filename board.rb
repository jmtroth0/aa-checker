require_relative 'piece'

class Board
  BOARD_SIZE = 8
  WHITE_ROWS_TO_SETUP = [0,1,2]
  BLACK_ROWS_TO_SETUP = [5,6,7]

  attr_reader :board

  def initialize(setup = true)
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    setup_board if setup
  end

  def [](pos)
    x, y = pos
    board[x][y]
  end

  def []=(pos, value)
    x, y = pos
    board[x][y] = value
  end

  def pieces
    board.flatten.compact
  end

  def dup
    new_board = Board.new(false)
    pieces.each { |piece| piece.dup(new_board) }
    new_board
  end

  def setup_board
    setup_white
    setup_black
  end

  def setup_white
    rows.each_with_index do |row, idx|
      if WHITE_ROWS_TO_SETUP.include?(idx)
        if idx.even? &&
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
  end

  def setup_black
    rows.each_with_index do |row, idx|
      if BLACK_ROWS_TO_SETUP.include?(idx)
        if idx.odd?
          row.each_with_index do |square, jdx|
            Piece.new([idx, jdx], self, :black) if jdx.odd?
          end
        else
          row.each_with_index do |square, jdx|
            Piece.new([idx, jdx], self, :black) if jdx.even?
          end
        end
      end
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE - 1) }
  end

  def render
    board.each_with_index do |row, idx|
      rendered_row = row.map { |square| square.nil? ? "[ ]" : "[#{square}]" }
      puts "#{idx} #{rendered_row.join("")}"
    end
    nil
  end

  def inspect
    render
  end

  private

  def rows
    board
  end

end
