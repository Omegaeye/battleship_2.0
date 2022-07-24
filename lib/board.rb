require './lib/cell'

class Board
  attr_reader :cells, :size

  def initialize(size)
    @size = size
    @letters_array = ('A'..'Z').to_a.first(@size)
    @cells = create_cells
  end

  def coordinates_hash(coordinates)
    hash = Hash.new { |k, v| k[v] = [] }

    coordinates.each do |coord|
      coord.split('')
      hash[:letters] << coord[0]
      hash[:numbers] << coord[1]
    end

    hash
  end

  def create_cells
    hash = {}

    @letters_array.each do |letter|
      cell_counter = 0

      @size.times do
        cell_counter += 1

        hash[letter + cell_counter.to_s] = if hash[letter + cell_counter.to_s].nil?
                                             Cell.new(letter + cell_counter.to_s)
                                           else
                                             Cell.new(letter + cell_counter.to_s)
                                           end
      end
    end

    hash
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coord|
        @cells[coord].place_ship(ship)
      end
      'success'
    else
      'fail'
    end
  end

  def render(show = false)
    numbers_array = (1..@size).to_a
    first_row = '  ' + numbers_array.join(' ') + " \n"

    rows = @letters_array.map do |letter|
      row_string = letter.to_s

      @cells.each do |_key, cell|
        row_string += " #{cell.render(show)}" if cell.coordinate.include?(letter)
      end

      [row_string += ' ']
    end

    first_row + rows.join("\n") + "\n"
  end

  def valid_cell_coordinates?(coordinates)
    return false unless valid_empty_coordinates?(coordinates)
    return true if valid_consecutive_numbers?(coordinates) && valid_duplicate_letters?(coordinates)
    return true if valid_duplicated_numbers?(coordinates) && valid_consecutive_letters?(coordinates)

    false
  end

  def valid_consecutive_numbers?(coordinates)
    coordinates_hash(coordinates)[:numbers].each_cons(2).all? do |num_1, num_2|
      num_1.to_i == num_2.to_i - 1
    end
  end

  def valid_consecutive_letters?(coordinates)
    coordinates_hash(coordinates)[:letters].each_cons(2).all? do |letter_1, letter_2|
      letter_1.ord.to_i == letter_2.ord.to_i - 1
    end
  end

  def valid_coordinate?(coordinate)
    !@cells[coordinate].nil?
  end

  def valid_duplicate_letters?(coordinates)
    coordinates_hash(coordinates)[:letters].each_cons(2).all? do |letter_1, letter_2|
      letter_1 == letter_2
    end
  end

  def valid_duplicated_numbers?(coordinates)
    coordinates_hash(coordinates)[:numbers].each_cons(2).all? do |num_1, num_2|
      num_1 == num_2
    end
  end

  def valid_empty_coordinates?(coordinates)
    coordinates.all? { |coord| @cells[coord].empty? }
  end

  def valid_placement?(ship, coordinates)
    coordinates.size == ship.length && valid_cell_coordinates?(coordinates) && coordinates.all? do |coord|
      valid_coordinate?(coord)
    end
  end
end
