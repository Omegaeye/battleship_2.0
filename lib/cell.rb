class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fire_upon = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon?
    @fire_upon
  end

  def fire_upon
    @fire_upon = true
    @ship.hit unless @ship.nil?
  end

  def render(show = false)
    if fire_upon?
      return "M" if  @ship.nil?
      return "X" if  @ship.sunk?
      return "H" if  !@ship.nil?
    end

    return "S" if !@ship.nil? && show == true

    "."
  end
end
