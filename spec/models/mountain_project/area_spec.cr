require "../../spec_helper"

Spectator.describe MountainProject::Area do
  subject(area) { MountainProject::Area.new(id) }
  around_each do |example|
    VCR.use_cassette("mountain_project/areas") do
      example.run
    end
  end

  provided id = 121105367 do
    expect(subject.name).to eq "Ashford Bouldering"
    expect(subject.areas.size).to eq 1
    expect(subject.access_notes).to be_empty
  end

  provided id = 105744307 do
    expect(subject.name).to eq "Vedauwoo Climbing"
  end

  provided id = 105745214 do
    expect(subject.name).to eq "Nautilus Rock Climbing"
    expect(subject.areas.size).to eq 0
    expect(subject.routes.size).to eq 132
  end

  provided id = 105716763 do
    expect(subject.name).to eq "Indian Creek Rock Climbing"
    expect(subject.access_notes).to contain(
      "The sandstone around Moab is fragile",
      "2022 Raptor Avoidance Areas"
    )
  end
end
