require 'colorize'
require 'byebug'

class Piece
  SLIDE_DELTAS = [[ 1, 1], [ 1, -1]]
  WHITE_JUMP_DELTAS =  [[ 2, 2], [ 2, -2]]
  BLACK_JUMP_DELTAS =  [[ -2, 2], [ -2, -2]]

  attr_reader :board, :color, :possible_moves
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
    @king = false
    board[pos] = self
  end

  def perform_moves(move_sequence)
    delta_sequence = convert_to_deltas(move_sequence)
    perform_moves!(delta_sequence) if valid_move_seq?(delta_sequence)
  end

  def valid_move_seq?(move_sequence)
    new_board = board.dup
    begin
      new_board[pos].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      puts e
      false
    else
      true
    end
  end

  def perform_moves!(delta_sequence)
    if delta_sequence.length == 1
      perform_slide(delta_sequence.first)
      return
    end

    delta_sequence.each do |delta|
      perform_jump(delta)
    end
  end

  def perform_slide(delta)
    destination = moved_pos(delta)
    unless board.on_board?(destination) &&
                  board[destination].nil? && slide_deltas.include?(delta)
      raise InvalidMoveError.new("Can't slide there.")
    end
    slide_to(destination)
    maybe_promote
    nil
  end

  def perform_jump(delta)
    jumped_location = moved_pos(delta.map { |coord_delta| coord_delta / 2 })
    destination = moved_pos(delta)
    unless board.on_board?(destination) && jump_deltas.include?(delta) &&
                          jump_possible?(destination, jumped_location)
      raise InvalidMoveError.new("Can't jump there.")
    end
    jump_to(destination, jumped_location)
    maybe_promote
    nil
  end

  def dup(new_board)
    Piece.new(pos, new_board, color)
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

  def maybe_promote
    @king = true if pos[0] == 0 || pos[0] == 7
  end

  def slide_to(destination)
    board[pos] = nil
    self.pos = destination
    board[pos] = self
  end

  def slide_deltas
    moves = king? ? [[-1, 1], [-1,-1]] + SLIDE_DELTAS : SLIDE_DELTAS
    color == :white ? moves : moves.map { |move| move * -1}
  end

  def jump_to(destination, jumped_location)
    board[pos] = nil
    self.pos = destination
    board[destination] = self
    board[jumped_location] = nil
  end

  def jump_deltas
    return WHITE_JUMP_DELTAS + BLACK_JUMP_DELTAS if king?
    deltas = color == :white ? WHITE_JUMP_DELTAS : BLACK_JUMP_DELTAS
  end

  def jump_possible?(moved_pos, jumped_location)
    !board[jumped_location].nil? &&
      board[moved_pos].nil? &&
      board[jumped_location].color != color
  end

  def move_diffs
    slide_deltas + jump_deltas
  end

  def moved_pos(delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def convert_to_deltas(move_sequence)
    delta_sequence = []
    new_pos = pos
    move_sequence.each do |move|
      delta_sequence << [move[0] - new_pos[0], move[1] - new_pos[1]]
      new_pos = move
    end

    delta_sequence
  end
end

class InvalidMoveError < StandardError
end
