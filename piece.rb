require 'colorize'

class Piece
  SLIDE_DELTAS = [[ 1, 1], [ 1, -1]]
  JUMP_DELTAS =  [[ 2, 2], [ 2, -2]]

  attr_reader :board, :color, :possible_moves
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
    @king = false
    board[pos] = self
  end

  def perform_slide(delta)
    unless board[moved_pos(delta)].nil? || slide_deltas.include?(delta)
      raise "Can't slide there."
    end
    board[pos] = nil
    self.pos = moved_pos(delta)
    board[pos] = self
    nil
  end



  def to_s
    "O".colorize(color)
  end

  def inspect
    [pos, color, king?].to_s
  end

  # private

  def king?
    @king
  end

  def move_diffs
    slide_deltas + jump_deltas
  end

  def slide_deltas
    moves = king? ? [[-1, 1], [-1,-1]] + SLIDE_DELTAS : SLIDE_DELTAS
    color == :white ? moves : moves.map { |move| move * -1}
  end

  def jump_deltas
    moves = king? ? [[-2, 2], [-2,-2]] + JUMP_DELTAS : JUMP_DELTAS
    color == :white ? moves : moves.map do |move|
      move[0] *= (-1)
      move
    end
  end

  def moved_pos(delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def add_delta!(delta)
    [pos[0] += delta[0], pos[1] += delta[1]]
    nil
  end
end
