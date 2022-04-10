require "xml"

class MountainProject::Route
  property \
    url : String?,
    raw : String?,
    xml : XML::Node?,
    name : String?,
    rating_yds : String?

  def initialize(@id : Int64)
  end

  def url
    @url ||= "https://www.mountainproject.com/route/#{@id}"
  end

  def raw : String
    @raw ||= HTTP::Client.get(url).try do |response|
      if [301, 302].includes?(response.status_code)
        HTTP::Client.get(@url = response.headers["Location"])
      else
        response
      end
    end.body
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
