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

  def perform_moves!(move_sequence)
    delta_sequence = move_sequence.split.convert_to_deltas
  end

  def perform_slide(delta)
    destination = moved_pos(delta)
    unless board.on_board?(destination) &&
                  board[destination].nil? && slide_deltas.include?(delta)
      raise "Can't slide there."
    end
    slide_to(destination)
    nil
  end

  def perform_jump(delta)
    jumped_location = moved_pos(delta.map { |coord_delta| coord_delta / 2 })
    destination = moved_pos(delta)
    unless board.on_board?(destination) && jump_deltas.include?(delta) &&
                          jump_possible?(destination, jumped_location)
      raise "Can't jump there."
    end
    jump_to(destination, jumped_location)
    nil
  end

  def to_s
    "O".colorize(color)
  end

  def inspect
    [pos, color, king?].to_s
  end

  private

  def king?
    @king
  end

  def slide_to(destination)
    board[pos] = nil
    self.pos = destination
    board[pos] = self
  end

  def jump_to(destination, jumped_location)
    board[pos] = nil
    self.pos = destination
    board[destination] = self
    board[jumped_location] = nil
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

  def jump_possible?(moved_pos, jumped_location)
    !board[jumped_location].nil? &&
      board[moved_pos].nil? &&
      board[jumped_location].color != color
  end

  def moved_pos(delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def convert_to_deltas(move_sequence)
    delta_sequence = []
    move_sequence.map {|move| [move[0] - pos[0], move[1] - pos[1]]}
  end


end
