class Piece
  SLIDE_DELTAS = [[ 1, 1], [ 1, -1]]
  JUMP_DELTAS =  [[ 2, 2], [ 2, -2]]

  attr_reader :pos, :board, :color, :possible_moves

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
    @king = false
    @slide_moves = []
    @jump_moves = []
    moves
  end

  def move

  def perform_slide(move)
    if slide_moves.include?(move)
      pos = move
    end
    moves
  end

  def perform_jump(move)
    if jump_moves.include?(move)
      pos = move
    end
    moves
  end

  def king?
    @king
  end

  def moves
    slide_deltas.each do |slide_delta| #=> slide check
      move = add_delta(slide_delta)
      if board[move].empty?
        slide_moves << move

      elsif board[move].color != color #=> jump check
        jump_deltas.each do |jump_delta|
          move = add_delta(jump_delta)
          jump_moves << move if board[move].empty?
        end
      end

    end
  end

  private

  def slide_deltas
    king? ? [[-1, 1], [-1,-1]] + SLIDE_DELTAS : SLIDE_DELTAS
  end

  def jump_deltas
    king? ? [[-2, 2], [-2,-2]] + JUMP_DELTAS : JUMP_DELTAS
  end

  def add_delta(delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end
end
