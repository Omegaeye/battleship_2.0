require "./lib/board"
require "./lib/ship"
require "pry"

class Game
  def initialize
    @board_size = nil
    @cpu_ships = generate_cpu_ships
    @cpu_board = nil
    @player_board = nil
    @player_ships = nil
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

      puts "Preparing boards...for battle!"

      turn

    elsif play_or_quite == "q"
      puts "Bye"
    else
      puts "Invalid choice"
      start
    end
  end

  def cpu_shot
    cpu_shot = @player_board.cells.keys.sample(1).join

    unless @player_board.cells[cpu_shot].fire_upon?
      cpu_shot = @player_board.cells.keys.sample(1).join
    end

    player_cell = @player_board.cells[cpu_shot]
    player_cell.fire_upon

    render_shots(cell: player_cell, shot: cpu_shot, pro_noun: ["My", "your"])
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

    @player_ships = [Ship.new("Submarine", 2), Ship.new("Cruiser", 3)]

    @player_ships.each do |ship|
      player_coordinates_input(ship)
    end
  end

  def player_coordinates_input(ship)
    puts @player_board.render(true)

    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"

    user_coordinates = gets.chomp.upcase.split(" ")

    until @player_board.valid_placement?(ship, user_coordinates) do
      puts "Invalid coordinates, please try again"
      user_coordinates = gets.chomp.upcase.split(" ")
    end

    @player_board.place(ship, user_coordinates)

    puts @player_board.render(true)
  end

  def player_shot
    player_shot = gets.chomp.upcase

    until @cpu_board.valid_coordinate?(player_shot) && !@cpu_board.cells[player_shot].fire_upon?
      puts "Please enter a valid coordinate:"
      player_shot = gets.chomp.upcase
    end

    cpu_cell = @cpu_board.cells[player_shot]
    cpu_cell.fire_upon

    render_shots(cell: cpu_cell, shot: player_shot, pro_noun: ["Your", "my"])
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
    puts "=============COMPUTER BOARD============="
    puts @cpu_board.render

    puts "==============PLAYER BOARD=============="
    puts @player_board.render(true)

    puts "Enter the coordinate for your shot:"

    player_shot

    cpu_shot

    if @cpu_ships.all? { |ship| ship.sunk?}
      puts "You have won"
    elsif @player_ships.all? { |ship| ship.sunk?}
      puts "You have Lost"
    else
      turn
    end
  end

  def render_shots(cell:, shot:, pro_noun:)
    if cell.render == "X"
      puts "#{pro_noun[0]} shot on #{shot} sunk #{pro_noun[1]} ship"
    elsif cell.render == "H"
      puts "#{pro_noun[0]} shot on #{shot} was a hit"
    elsif cell.render == "M"
      puts "#{pro_noun[0]} shot on #{shot} was a miss"
    end
  end
end

Game.new.start
