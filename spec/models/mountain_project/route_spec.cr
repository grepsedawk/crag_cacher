require "../../spec_helper"

Spectator.describe MountainProject::Route do
  describe "#url" do
    it "returns the route url" do
      route = MountainProject::Route.new(id: 1)
      expect(route.url).to eq("http://www.mountainproject.com/route/1")
    end
  end

  describe "#name" do
    it "can fetch the route name from mountain project" do
      route = MountainProject::Route.new(id: 105798994)
      expect(route.name).to eq("High Exposure")
    end
  end
end
