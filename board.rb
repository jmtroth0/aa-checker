require_relative 'piece'

class Board
  BOARD_SIZE = 8
  ROWS_TO_SETUP = {0 => :white, 1 => :white, 2 => :white,
                   5 => :black, 6 => :black, 7 => :black }
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

  def move(move_sequence)
    self[move_sequence.first].perform_moves(move_sequence)
  end

  def pieces
    board.flatten.compact
  end

  def piece_at?(pos)
    !!self[pos]
  end

  def lost?(color)
    pieces.all? { |piece| piece.color != color}
  end

  def over?
    lost?(:black) || lost?(:white)
  end

  def winner
    return :white if lost?(:black)
    return :black if lost?(:white)
    false
  end

  def dup
    new_board = Board.new(false)
    pieces.each { |piece| piece.dup(new_board) }
    new_board
  end

  def setup_board
    rows.each_with_index do |row, idx|
      if ROWS_TO_SETUP.keys.include?(idx)
        row.each_with_index do |square, jdx|
          Piece.new([idx, jdx], self, ROWS_TO_SETUP[idx]) if (jdx+idx).even?
        end
      end
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE - 1) }
  end

  def render
    puts "   " + (1..8).to_a.join("  ")

    board.each_with_index do |row, idx|
      rendered_row = row.map { |square| square.nil? ? "[ ]" : "[#{square}]" }
      puts "#{idx + 1} #{rendered_row.join("")}"
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
