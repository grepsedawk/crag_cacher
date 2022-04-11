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
  end

  provided id = 105744307 do
    expect(subject.name).to eq "Vedauwoo Climbing"
  end

  provided id = 105745214 do
    expect(subject.name).to eq "Nautilus Rock Climbing"
    expect(subject.areas.size).to eq 0
    expect(subject.routes.size).to eq 132
  end
end
