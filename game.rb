require_relative 'board'

class Game
  attr_accessor :current_player, :other_player
  attr_reader :board

  def initialize(board)
    @board = board
    @current_player = HumanPlayer.new(:white, board)
    @other_player = HumanPlayer.new(:black, board)
  end

  def play
    board.render

    until board.over?
      puts "It is your turn #{current_player.color.to_s.capitalize}"
      play_turn
      board.render
      switch_players
    end

    puts "Congrats #{board.winner}, you won!"
  end

  def play_turn
    begin
      moves = current_player.prompt
      if !board.piece_at?(moves.first)
        raise InvalidMoveError.new("You don't have a piece there")
      elsif !board[moves.first].is_color?(current_player.color)
        raise InvalidMoveError.new("Move your own pieces.")
      end
    rescue InvalidMoveError => e
      puts e
      retry
    end
    board.move(moves)
  end

  private

  def switch_players
    self.current_player, self.other_player = other_player, current_player
  end
end

class HumanPlayer
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def prompt
    print "Where would you like to move. If there are multiple places, just add"
    puts " a space between locations. Put the row first, then the column"

    begin
      moves = convert_to_move_sequence(gets.chomp)
    raise "Not on Board" unless moves.all? { |move| board.on_board?(move) }
    rescue => e
      puts e
      puts "Try again."
      retry
    end
    moves
  end

  def convert_to_move_sequence(move)
    move.split.map { |move| move.split("").map { |coord| coord.to_i - 1 } }
  end
end

class ComputerPlayer
  def initialize(color, board)
    @color = color
    @board = board
  end

  def moves
    board.pieces.each do |piece|
      
    end
  end
end
