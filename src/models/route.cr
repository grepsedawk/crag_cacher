require "xml"

class MountainProject::Route
  property \
    xml : XML::Node?,
    name : String?,
    rating_yds : String?

  def initialize(@id : Int64)
  end

  def url
    "https://www.mountainproject.com/route/#{@id}"
  end

  def raw : String
    @raw ||= HTTP::Client.get(url).body
  end

  def xml
    @xml ||= XML.parse_html(raw)
  end

  def name
    @name ||= xml
      .xpath_node("//h1")
      .try &.text.strip
  end

  def rating_yds
    @rating_yds ||= xml
      .xpath_node("//span[@class='rateYDS']")
      .try &.text.gsub("YDS", "").strip
  end
end
