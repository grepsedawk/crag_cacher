require "../../spec_helper"

Spectator.describe MountainProject::Route do
  describe "#url" do
    it "returns the route url" do
      route = MountainProject::Route.new(id: 1)
      expect(route.url).to eq("https://www.mountainproject.com/route/1")
    end

    it "returns the new URL after a redirect" do
      route = MountainProject::Route.new(id: 105798994)
      route.raw # trigger the redirect
      expect(route.url).to eq("https://www.mountainproject.com/route/105798994/high-exposure")
    end
  end

  describe "#name" do
    it "can fetch the route name from mountain project" do
      route = MountainProject::Route.new(id: 105798994)
      expect(route.name).to eq("High Exposure")
    end
  end
end
