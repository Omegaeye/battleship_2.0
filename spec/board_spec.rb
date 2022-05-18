require './lib/board'
require './lib/ship'

RSpec.describe Board do
  before do
    @board = Board.new(4)
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2) 
  end
  
  describe "#attributes" do
    it "has board_size" do
      expect(@board.size).to eq(4)
    end
  end

  describe "#create_cells" do
    it "generate board according to size" do
      expect(@board.create_cells.size).to eq(16)
    end
  end

  describe "#valid_coordinate?" do
    it "returns true if coordinate is valid" do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("A22")).to be false
    end
  end

  describe "#valid_placement?" do
    it "returns false when coordinates size is not the same as ship length" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to be false
      expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to be false
    end

    it "returns false when coordinates are not consecutive" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to be false
      expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to be false
    end

    it "returns false when coordinates are diagonal" do
      expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to be false
      expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to be false
    end

    it "returns true when coordinates are valid" do
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to be true
      expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to be true
    end
    
    it "returns false when coordinate is already filled" do
      @board.place(@cruiser, ["A1", "A2", "A3"])

      expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to be false
    end
    
  end

  describe "#place" do
    before do
      @board.place(@cruiser, ["A1", "A2", "A3"])
      @cell_1 = @board.cells["A1"]
      @cell_2 = @board.cells["A2"]
      @cell_3 = @board.cells["A3"] 
    end
    
    it "assigns the ship coordinates to cells" do
      expect(@cell_1.ship).to eq(@cruiser)
      expect(@cell_2.ship).to eq(@cruiser)
      expect(@cell_3.ship).to eq(@cruiser)
      expect(@cell_3.ship).to eq(@cell_2.ship)
    end
  end

  describe "#render" do
    before do
      @board.place(@cruiser, ["A1", "A2", "A3"])
    end

    it "returns a string of numbers and letters" do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it "returns a string with the ship when true is passed" do
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
    end
  end
end
