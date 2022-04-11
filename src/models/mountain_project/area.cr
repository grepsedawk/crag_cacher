class MountainProject::Area
  include LuckyCache::Cachable

  property \
    id : Int64,
    url : String?,
    raw : String?,
    name : String?,
    areas : Array(MountainProject::Area)?,
    routes : Array(MountainProject::Route) = [] of MountainProject::Route

  property lexbor : Lexbor::Parser?

  def initialize(@id : Int64, @name : String? = nil)
  end

  def url
    @url ||= "https://www.mountainproject.com/area/#{@id}"
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
    @name ||= lexbor
      .nodes(:h1)
      .first
      .inner_text
      .gsub("\n", "")
      .squeeze(' ')
      .strip
  end

  def areas : Array(MountainProject::Area)
    @areas ||= lexbor
      .css(".mp-sidebar")
      .first
      .scope
      .nodes(:a)
      .compact_map do |node|
        node.attributes["href"].match(/\/area\/(\d+)/).try do |match|
          MountainProject::Area.new(
            id: match[1].to_i,
            name: node.inner_text.strip
          )
        end
      end.to_a
  end

  def routes : Array(MountainProject::Route)
    return [] of MountainProject::Route

    if @routes.empty?
      @routes = lexbor
        .css(".mp-sidebar")
        .first
        .scope
        .nodes(:a)
        .compact_map do |node|
          node.attributes["href"].match(/\/route\/(\d+)/).try do |match|
            MountainProject::Route.new(
              id: match[1].to_i
            )
          end
        end.to_a
    end

    if @routes.empty?
      @routes = areas.flat_map(&.routes)
    end || [] of MountainProject::Route

    @routes
  end

  def load!
    self.name
    self.areas
    self.routes
  end
end
