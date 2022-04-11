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
    expect(route.rating).to eq("5.6 YDS")
    expect(route.description).to start_with "High Exposure, aka High E. The climbing itself is flawless,"
    expect(route.description).to end_with "a first pitch that rivals the second in terms of quality."
    expect(route.description).to contain(
      "Uberfall.\n\n P1",
      "[Bonnie's Roof](/mountain_project/routes/105801433/bonnies-roof)",
      "[bolted rap stations](/mountain_project/areas/105798167/the-gunks#a_114577987)"
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
    expect(route.type).to eq "Trad, 250 ft (76 m), 2 pitches"
    expect(route.first_ascent).to eq "Hans Kraus & Fritz Wiessner - 1941"
    expect(route.breadcrumbs).to contain(
      "i. High E",
      "Trapps",
      "Gunks",
      "New York",
      "All Locations"
    )
  end

  provided id = 105835705 do
    expect(route.name).to eq("Southeast Buttress")
    expect(route.rating).to eq("5.6 YDS")
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
    expect(route.type).to eq "Trad, Alpine, 700 ft (212 m), 5 pitches, Grade II"
    expect(route.first_ascent).to eq "Wilts and Spencer Austin, 1943"
  end

  provided id = 116685137 do
    expect(route.name).to eq "Ski Boot Slab"
    expect(route.rating).to eq "5.15d YDS | V17 YDS | AI6 M13+ C5+ Steep Snow X"
  end
end
