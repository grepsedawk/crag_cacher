class MountainProject::Route
  include LuckyCache::Cachable

  property \
    id : Int64,
    url : String?,
    raw : String?,
    name : String?,
    breadcrumbs : String?,
    type : String?,
    first_ascent : String?,
    rating : String?,
    mp_votes : String?,
    description : String?,
    photos : Array(MountainProject::Photo)?

  property lexbor : Lexbor::Parser?

  def initialize(@id : Int64, @name : String? = nil)
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

  def breadcrumbs
    @breadcrumbs ||= html_to_markdown(lexbor.css(".mb-half.small.text-warm").first)
  end

  def type
    @type ||= lexbor.css(".description-details td")[1].inner_text.strip
  end

  def first_ascent
    @first_ascent ||= lexbor.css(".description-details td")[3].inner_text.strip
  end

  def rating
    @rating ||= lexbor.css("h2.inline-block.mr-2").first.children.map do |node|
      if node.inner_text.includes? "YDS"
        node.inner_text.strip
      elsif node.tag_sym == :_text
        node.tag_text.strip
      end
    end.reject(&.blank?).join " | "
  end

  def mp_votes
    @mp_votes ||= lexbor
      .css("span:has(.scoreStars)")
      .first
      .tag_text
      .gsub("\n", "")
      .squeeze(' ')
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
        html_to_markdown node.scope.nodes(:div).first
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
        html_to_markdown node.scope.nodes(:div).first
      end || "Protection not found"
  end

  def html_to_markdown(node)
    HtmlToMarkdown.convert(node)
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
