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
       user_submarine_coordinates = gets.chomp.upcase
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
       user_cruiser_coordinates = gets.chomp.upcase
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
    ships = [["Battleship", 4], ["Cruiser", 3], ["Submarine", 3], ["Destroyer", 2]]

    ships.shuffle.take(2).map do |ship|
      Ship.new(ship[0], ship[1])
    end
  end
end

Game.new.start
