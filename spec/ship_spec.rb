require "./lib/ship"

RSpec.describe Ship do
  before do
    @ship = Ship.new("Cruiser", 3)
  end

  describe "#initialize" do
    it "should initialize an instance of a Ship" do
      expect(@ship).to be_instance_of(Ship)
    end
  end

  describe "#attributes" do
    it "should have a name" do
      expect(@ship.name).to eq("Cruiser")
    end

    it "should have a length" do
      expect(@ship.length).to eq(3)
    end

    it "should have health that equals to length" do
      expect(@ship.health).to eq(@ship.length)
    end
  end

  describe "#sunk?" do
    it "returns false when health is greater than zero" do
      expect(@ship.sunk?).to be false
    end
  end

  describe "#hit" do
    it "minus 1 from health" do
      expect{ @ship.hit }.to change{ @ship.health }.from(3).to(2)
    end
  end
end
