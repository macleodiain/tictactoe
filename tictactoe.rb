# Represents the board on which the game is played. 3*3 grid
# Can output the board (to_s), update_board and check if a winning line has been found
class Board
  attr_reader :board

  def initialize
    @board = Array.new(3) { Array.new(3, " ") }
  end

  def to_s
    # Outputs the board state

    # print the top line
    # each line is one tab in so always starts with \t
    puts "\t-------------"
    @board.each do |row|
      print "\t"
      row.each do |cell|
        # print the cell with a | before it to make the vertical lines in the board
        print "| #{cell} "
      end
      # add | on the end to print the last vertical line
      print "|\n"
      # bottom line
      puts "\t-------------"
    end
  end

  def update_board(move)
    # update the board at the position indicated (move[0]move[1]) with the token indicated move[2]
    # ie move might look like [0,0,"X"] indicating that the first cell should be marked as X
    @board[move[0]][move[1]] = move[2]
  end

  def has_won?(current_player)
    # gets the columns in the board to check for wins
    columns = [[],[],[]]
    @board.each do |row|
      columns[0].push(row[0])
      columns[1].push(row[1])
      columns[2].push(row[2])
    end
    # gets horizontals to check
    horizontals = [[], []]
    @board.each_with_index do |row, index|
      horizontals[0].push(row[index])
      horizontals[1].push(row[2 - index])
    end
    # gets rows to check.  basically this is a copy of board as its already laid out as rows
    rows = []
    @board.each do |row|
      rows.push(row)
    end

    def check?(rows, columns, horizontals, current_player)
      # checks each of the arrays to see if any row/column/horizontal has all cells the same as the players token
      # if win return true else false
      if rows.any? { |row| row.all? { |cell| cell == current_player.token } }
        true
      elsif columns.any? { |row| row.all? { |cell| cell == current_player.token } }
        true
      elsif horizontals.any? { |row| row.all? { |cell| cell == current_player.token } }
        true
      else
        false
      end
    end

    if(check?(rows, columns, horizontals, current_player))
      # output win text and return true to end the game (game_finished = true)
      puts "Congratulations, #{current_player.name}!  You WIN!"
      true
    else
      # return false if no win (game_finished = false)
      false
    end
  end
   
end

class Player
  # Player class.  Stores name and player token (X or O).
  # Can also get and validate the players chosen move
  attr_reader :name, :token

  def initialize(player_number, token)
    puts "Player #{player_number}:  Please enter your name "
    @name = gets.chomp
    @token = token
    puts "Hi, #{@name}.  You will be playing as \'#{token}\'"
  end

  def get_move(board)
    # get and validate users input then return an array with the positions required on the board and the players token
    while true
      puts "#{@name}, please enter your move: (enter row then a comma then the column, i.e 1,1 for the first cell)"
      input = gets.chomp
      # regexp means any number between from 1 to 3 followed by a comma follwed by a number from 1 to 3
      if input.match(/[1-3][,][1-3]/) 
        # if input is valid then split it up to get each number (to_i) from the string.  -1 so 1,1 will = 0,0 for accessing array properly
        output = input.split(',').push(token)
        output[0] = output[0].to_i - 1
        output[1] = output[1].to_i - 1
        # check if the position chosen is free.  i.e. contains a space instead of an x or o
        if board.dig(output[0], output[1]) == " "
          return output
        else
          # warning if cell is already ocupued
          puts "That cell is already occupied!"
        end
      else
        # warning if input was not in correct format
        puts "Input was not recognised:  Try again."
      end
    end
    
  end
end

class Game
  # basic game class that contains board, players and start game method
  def initialize
    puts "---=== TIC TAC TOE ===---\n\n"
    @board = Board.new
    @player_one = Player.new("one", "X")
    @player_two = Player.new("two", "O")
    @current_player = @player_one
    @game_finished = false
  end

  def start
    # gets/validates the players move then updates the board
    # draws the board with to_s
    # checks if the game has been won yet and if so updates game_finished
    # if game has not been won yet, swap player and repeat
    # if after 9 turns there is no winner the game ends

    turn_counter = 0
    until @game_finished
      @board.update_board(@current_player.get_move(@board.board))
      @board.to_s
      @game_finished = @board.has_won?(@current_player)
      swap_player
      turn_counter += 1
      if turn_counter == 9
        puts "This game is a draw!"
        @game_finished = true 
      end
    end
  end

  def swap_player
    # if it was player ones turn, change to player two and vice versa
    if @current_player == @player_one
      @current_player = @player_two
    elsif @current_player == @player_two
      @current_player = @player_one
    end
  end
end

# create a game then start it
game = Game.new
game.start
