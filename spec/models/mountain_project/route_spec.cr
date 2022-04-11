require "../../spec_helper"

Spectator.describe MountainProject::Route do
  subject(route) { MountainProject::Route.new(id) }
  around_each do |example|
    VCR.use_cassette("mountain_project/routes") do
      example.run
    end
  end

  provided id = 105798994 do
    expect(route.name).to eq("High Exposure")
    expect(route.rating_yds).to eq("5.6")
    expect(route.description).to start_with "High Exposure, aka High E. The climbing itself is flawless,"
    expect(route.description).to end_with "a first pitch that rivals the second in terms of quality."
    expect(route.description).to contain(
      "[Bonnie's Roof](https://www.mountainproject.com/route/105801433/bonnies-roof)",
      "[bolted rap stations](https://www.mountainproject.com/area/105798167/the-gunks#a_114577987)"
    )
    expect(route.protection).to contain(
      "A large cam (e.g #4 camalot) fits well into the large crack"
    )
    expect(route.photos.size).to eq(12)
    expect(route.photos.first).to be_a(MountainProject::Photo)
    expect(route.photos.first.thumbnail_url).to eq(
      "https://cdn2.apstatic.com/photos/climb/117718492_smallMed_1568038766.jpg"
    )
    expect(route.url).to eq("https://www.mountainproject.com/route/105798994/high-exposure")
  end

  provided id = 105835705 do
    expect(route.name).to eq("Southeast Buttress")
    expect(route.rating_yds).to eq("5.6")
    expect(route.description).to start_with "You can really climb all over the southest buttress. "
    expect(route.description).to end_with "A spectacular climb not to be missed."
    expect(route.description).to contain(
      "Many people start up and to the right a little",
      "after 3 pitches",
      "many options, passing people is generally easy",
    )
    expect(route.protection).to eq "Normal full rack.  No huge cams needed."
    expect(route.photos.size).to eq(12)
    expect(route.photos.first).to be_a(MountainProject::Photo)
    expect(route.photos.first.thumbnail_url).to eq(
      "https://cdn2.apstatic.com/photos/climb/118352963_smallMed_1581961735.jpg"
    )
    expect(route.url).to eq("https://www.mountainproject.com/route/105835705/southeast-buttress")
  end
end
