require "lexbor"

class MountainProject::Route
  include LuckyCache::Cachable

  property \
    url : String?,
    raw : String?,
    name : String?,
    rating_yds : String?,
    description : String?,
    photos : Array(MountainProject::Photo)?

  property lexbor : Lexbor::Parser?

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

  def lexbor
    @lexbor ||= Lexbor::Parser.new(raw)
  end

  def name
    @name ||= lexbor.nodes(:h1).first.inner_text.strip
  end

  def rating_yds
    @rating_yds ||= lexbor
      .css("span.rateYDS")
      .first
      .inner_text
      .gsub("YDS", "")
      .strip
  end

  def description : String
    @description ||= lexbor
      .css("div.max-height-xs-600")
      .find do |node|
        node.scope.nodes(:h2).first?.try do |h2|
          h2.inner_text.strip == "Description"
        end
      end
      .try do |node|
        html_to_markdown(node)
      end || "Description not found"
  end

  def protection : String
    @protection ||= lexbor
      .css("div.max-height-xs-600")
      .find do |node|
        node.scope.nodes(:h2).first?.try do |h2|
          h2.inner_text.strip == "Protection"
        end
      end
      .try do |node|
        html_to_markdown(node)
      end || "Protection not found"
  end

  def html_to_markdown(node)
    node.scope.nodes(:p).map do |child|
      child.children.map do |child_child|
        case child_child.tag_sym
        when :a
          "[#{child_child.inner_text.strip}](#{child_child.attributes["href"]})"
        when :img
          "![#{child_child.attributes["alt"]}](#{child_child.attributes["src"]})"
        when :_text
          child_child.tag_text.strip
        else
          child_child.inner_text.strip
        end
      end.join " "
    end.join("\n\n")
  end

  record \
    MountainProject::Photo,
    thumbnail_url : String?,
    url : String? do
    def url
      @url || @thumbnail_url
    end
  end

  # TODO: more photos url is https://www.mountainproject.com/ajax/route/105798994/more-photos
  def photos : Array(MountainProject::Photo)
    @photos ||= lexbor
      .css("div.mt-3")
      .find do |node|
        node.scope.nodes(:h2).first?.try do |h2|
          h2.children.find do |child|
            child.tag_text.strip == "Photos"
          end
        end
      end
      .try do |node|
        node.scope.nodes(:img)
          .reject { |img| img.attributes["src"]?.try &.includes?("/img/") }
          .map do |img|
            MountainProject::Photo.new(
              img.attributes["data-src"]? || img.attributes["src"]?,
              img.attributes["data-original"]?
            )
          end.to_a
      end || [] of MountainProject::Photo
  end
end
