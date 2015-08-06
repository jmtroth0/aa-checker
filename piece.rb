class Piece
  DELTAS =      [[ 1, 1], [ 1,-1]]
  KING_DELTAS = [[-1, 1], [-1,-1]] + DELTAS

  def initialize
    @king = false
  end

  def king?
    @king
  end
end
