require "../../spec_helper"

Spectator.describe MountainProject::Route do
  around_each do |example|
    VCR.use_cassette("mountain_project/routes") do
      example.run
    end
  end

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

  describe "#rating_yds" do
    it "can fetch the route rating from mountain project" do
      route = MountainProject::Route.new(id: 105798994)
      expect(route.rating_yds).to eq("5.6")
    end
  end

  describe "#description" do
    it "scrapes mountain project description as markdown" do
      route = MountainProject::Route.new(id: 105798994)
      expect(route.description).to start_with "High Exposure, aka High E. The climbing itself is flawless,"
      expect(route.description).to end_with "a first pitch that rivals the second in terms of quality."
      expect(route.description).to contain(
        "Uberfall.\n\nP1",
        "[Bonnie's Roof](https://www.mountainproject.com/route/105801433/bonnies-roof)",
        "[bolted rap stations](https://www.mountainproject.com/area/105798167/the-gunks#a_114577987)"
      )
    end
  end

  describe "#protection" do
    it "can fetch the route protection from mountain project" do
      route = MountainProject::Route.new(id: 105798994)
      expect(route.protection).to contain(
        "A large cam (e.g #4 camalot) fits well into the large crack"
      )
    end
  end

  describe "#photos" do
    it "fetches the route photos from mountain project" do
      route = MountainProject::Route.new(id: 105798994)
      expect(route.photos.size).to eq(12)
      expect(route.photos.first).to be_a(MountainProject::Photo)
      expect(route.photos.first.thumbnail_url).to eq("https://cdn2.apstatic.com/photos/climb/117718492_smallMed_1568038766.jpg")
    end
  end
end
