class Game
  def initialize(board)
    player1 = HumanPlayer.new(:white, board)
    player2 = HumanPlayer.new(:black, board)
  end

  def play
    until over?
      play_turn
      board.render
    end
  end

  def play_turn
    
  end
end


class HumanPlayer
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def prompt
    puts "Where would you like to move. If there are multiple places, just add\
      a space between locations."

    begin
      moves = convert_to_move_sequence(gets.chomp)
    raise "Not on Board" unless moves.all { |move| board.on_board?(move) }
    rescue => e
      puts e
      puts "Try again."
    end
  end

  def convert_to_move_sequence(move)
    move.split.map { |move| move.map { |coord| coord + 1 } }
  end
end
