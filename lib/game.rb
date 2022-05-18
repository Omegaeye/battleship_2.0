require "./lib/board"
require "./lib/ship"
require "pry"
class Game

  def initialize
    @cpu_ships = generate_cpu_ships
    @cpu_board = nil
    @player_board = nil
    @board_size = nil
  end

  def start
    puts "Welcome to BATTLESHIP \n"
    puts "Enter p to play. Enter q to quit"
    play_or_quite = gets.chomp.downcase

    if play_or_quite == "p"
      puts "Please enter the board size you want to use minimum 4 to 10"

      @board_size = gets.chomp.to_i

      @cpu_board = Board.new(@board_size)

      place_cpu_ships(@cpu_board)

      place_player_ships

      turn

    elsif play_or_quite == "q"
      puts "Bye"
    else
      puts "Invalid choice"
      start
    end
  end

  def place_cpu_ships(board)
    @cpu_ships.each do |ship|
      coordinates = valid_cpu_coordinates(board, ship)
      board.place(ship, coordinates)
    end
  end

  def place_player_ships
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long. for exp: A1 A2 A3"

    @player_board = Board.new(@board_size)

    player_coordinates_input

    ship = Ship.new("Submarine", 2)

    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"

    user_submarine_coordinates = gets.chomp.upcase.split(" ")

    until @player_board.valid_placement?(ship, user_submarine_coordinates) do
       puts "Invalid coordinates, please try again"
       user_submarine_coordinates = gets.chomp.upcase.split(" ")
    end

    @player_board.place(ship, user_submarine_coordinates)
    puts @player_board.render(true)
  end

  def player_coordinates_input
    puts @player_board.render(true)

    ship = Ship.new("Cruiser", 3)
    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"

    user_cruiser_coordinates = gets.chomp.upcase.split(" ")

    until @player_board.valid_placement?(ship, user_cruiser_coordinates) do
       puts "Invalid coordinates, please try again"
       user_cruiser_coordinates = gets.chomp.upcase.split(" ")
    end

    @player_board.place(ship, user_cruiser_coordinates)

    puts @player_board.render(true)
  end

  def valid_cpu_coordinates(board, ship)
    coordinates = []

    until board.valid_placement?(ship, coordinates) do
      coordinates = board.cells.keys.sample(ship.length)
    end

    coordinates
  end


  def generate_cpu_ships
    ships = [["Battleship", 4], ["Cruiser", 3], ["Submarine", 2], ["Destroyer", 2]]

    ships.shuffle.take(2).map do |ship|
      Ship.new(ship[0], ship[1])
    end
  end

  def turn
    puts "Preparing boards...for battle!"
    sleep(2)
    puts "=============COMPUTER BOARD============="
    puts @cpu_board.render

    puts "==============PLAYER BOARD=============="
    puts @player_board.render(true)

    puts "Enter the coordinate for your shot:"
    player_shot = gets.chomp.upcase

    until @cpu_board.valid_coordinate?(player_shot) && !@cpu_board.cells[player_shot].fire_upon?
      puts "Please enter a valid coordinate:"
      player_shot = gets.chomp.upcase
    end

    cpu_shot = @player_board.cells.keys.sample(1).join

    unless @player_board.cells[cpu_shot].fire_upon?
      cpu_shot = @player_board.cells.keys.sample(1).join
    end

    @cpu_board.cells[player_shot].fire_upon

    @player_board.cells[cpu_shot].fire_upon

    if @player_board.cells[cpu_shot].render == "X"
      puts "My shot on #{cpu_shot} sunk your ship"
    elsif @player_board.cells[cpu_shot].render == "H"
      puts "My shot on #{cpu_shot} was a hit"
    elsif @player_board.cells[cpu_shot].render == "M"
      puts "My shot on #{cpu_shot} was a miss"
    end

    if @cpu_board.cells[player_shot].render == "X"
      puts "Your shot on #{player_shot} sunk my ship"
    elsif @cpu_board.cells[player_shot].render == "H"
      puts "Your shot on #{player_shot} was a hit"
    elsif @cpu_board.cells[player_shot].render == "M"
      puts "Your shot on #{player_shot} was a miss"
    end
  end
end

Game.new.start
