require "../../spec_helper"

Spectator.describe MountainProject::MobilePackage do
  subject { MountainProject::MobilePackage.new(id) }

  # TODO: vcr, gzip didn't work too well with it
  # TODO: not this ID lol it's huge
  # TODO: Fuzz testing would be cool here
  provided id = 105708956 do
    expect(subject.id).to eq(id)
    expect(subject.url).to eq "https://www.mountainproject.com/files/mobilePackages/climb/V2-105708956.gz"

    count = 0
    pp(subject.each_resource do |object|
      count += 1
    end)
    expect(count).to eq 125594
  end
end
