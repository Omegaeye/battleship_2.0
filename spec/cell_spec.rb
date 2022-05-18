require "./lib/ship"
require "./lib/cell"

RSpec.describe Cell do
  before do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#attributes" do
    it "has coordinate" do
      expect(@cell.coordinate).to eq("B4")
    end

    it "has a ship default nil" do
      expect(@cell.ship).to be nil
    end
  end

  describe "#empty?" do
    it "returns true if cell does not have a ship" do
      expect(@cell.empty?).to be true
    end
  end

  describe "#place_ship" do
    before do
      @cell.place_ship(@cruiser)
    end

    it "assigns to @ship" do
      expect(@cell.ship).to be @cruiser
    end

    it "place ship on a coordinate" do
      expect(@cell.empty?).to be false
    end
  end

  describe "#fire_upon?" do
    it "returns fire_upon" do
      expect(@cell.fire_upon?).to be false
    end
  end

  describe "#fire_upon" do
    it "hit the ship if ship is not nil" do
      @cell.place_ship(@cruiser)

      expect{ @cell.fire_upon }.to change{ @cell.ship.health }.from(3).to(2)
    end

    it "returns 'Miss' if there is no ship in cell" do
      expect(@cell.fire_upon).to eq("Miss")
    end
  end

  describe "#render" do
    before do
      @cell_1 = Cell.new("B4")
      @cell_2 = Cell.new("C3")
    end

    it "returns '.' as default" do
      expect(@cell_1.render).to eq(".")
    end

    it "returns 'M' when fire_upon is true and ship is nil" do
      @cell_1.fire_upon

      expect(@cell_1.render).to eq("M")
    end

    it "returns 'S' if true is passed in" do
      @cell_2.place_ship(@cruiser)

      expect(@cell_2.render(true)).to eq("S")
    end

    it "returns 'H' if fire_upon is true and ship is not nil" do
      @cell_2.place_ship(@cruiser)
      @cell_2.fire_upon

      expect(@cell_2.render).to eq("H")
      expect(@cruiser.sunk?).to be false
    end

    it "returns 'X' if fire_upon is true and ship is sunk" do
      @cell_2.place_ship(@cruiser)
      @cell_2.fire_upon
      @cruiser.hit
      @cruiser.hit

      expect(@cruiser.sunk?).to be true
      expect(@cell_2.render).to eq("X")
    end
  end
end
