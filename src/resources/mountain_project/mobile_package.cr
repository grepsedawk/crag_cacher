class MountainProject::MobilePackage
  property \
    id : Int64,
    failures : Array(String) = [] of String

  def initialize(@id : Int64); end

  def url
    "https://www.mountainproject.com/files/mobilePackages/climb/V2-#{id}.gz"
  end

  def raw
    HTTP::Client.get(url).body
  end

  def file
    File.tempfile("mountain_project_#{id}", ".multi_json.gz").try do |file|
      file.print(raw)
      yield file.path
      file.delete
    end
  end

  def decompressed
    file do |path|
      Compress::Gzip::Reader.open(path) do |gzip|
        yield gzip
      end
    end
  end

  def each_raw(&block : String, UInt64 ->)
    failures = [] of String
    decompressed do |gzip|
      loop do
        begin
          size = IO::ByteFormat::LittleEndian.decode(UInt64, gzip)
          signature = IO::ByteFormat::LittleEndian.decode(UInt64, gzip)

          gzip.gets(limit: size).try do |json|
            # begin
            yield json, signature
            # rescue
            #   failures << json
            # end
          end
        rescue IO::EOFError
          return failures
        end
      end
    end

    failures
  end

  def each_resource
    each_raw do |json, signature|
      yield case signature
      when 1
        Header.from_json json
      when 2
        Area.from_json json
      when 3
        Route.from_json json
      when 5
        Array(Rating).from_json json
      when 7
        AccessNote.from_json json
      when 8
        Array(Metadata).from_json json
      when 9
        User.from_json json
      when 10
        Trail.from_json json
      else
        JSON.parse(json)
      end
    end
  end

  class Header
    include JSON::Serializable

    property id : Int64
    @[JSON::Field(key: "buildDate")]
    property build_date : Int64
    @[JSON::Field(key: "numLines")]
    property num_lines : Int64

    def initialize(@id : Int64, @build_date : Int64, @num_lines : Int64); end
  end

  class Area
    include JSON::Serializable

    property id : Int64
    property title : String
    @[JSON::Field(key: "titleSearch")]
    property title_search : String
    @[JSON::Field(key: "userId")]
    property user_id : Int64
    @[JSON::Field(key: "parentId")]
    property parent_id : Int64
    property x : Int64
    property y : Int64
    @[JSON::Field(key: "numRoutes")]
    property num_routes : Int64
    @[JSON::Field(key: "numTrad")]
    property num_trad : Int64
    @[JSON::Field(key: "numSport")]
    property num_sport : Int64
    @[JSON::Field(key: "numTR")]
    property num_tr : Int64
    @[JSON::Field(key: "numRock")]
    property num_rock : Int64
    @[JSON::Field(key: "numIce")]
    property num_ice : Int64
    @[JSON::Field(key: "numBoulder")]
    property num_boulder : Int64
    @[JSON::Field(key: "numAid")]
    property num_aid : Int64
    @[JSON::Field(key: "numMixed")]
    property num_mixed : Int64
    @[JSON::Field(key: "numAlpine")]
    property num_alpine : Int64
    @[JSON::Field(key: "pageViewsMonthly")]
    property page_views_monthly : Int64
    @[JSON::Field(key: "accessNotes")]
    property access_notes : Array(Int64) = [] of Int64
    property classics : Array(Int64) = [] of Int64
    @[JSON::Field(key: "photoCount")]
    property photo_count : Int64
    property climate : String
  end

  class Route
    include JSON::Serializable

    property id : Int64
    property title : String
    @[JSON::Field(key: "titleSearch")]
    property title_search : String
    @[JSON::Field(key: "userId")]
    property user_id : Int64
    @[JSON::Field(key: "parentId")]
    property parent_id : Int64
    @[JSON::Field(key: "positionInArea")]
    property position_in_area : Int64
    @[JSON::Field(key: "numPitches")]
    property num_pitches : Int64
    @[JSON::Field(key: "accessNotes")]
    property access_notes : Array(Int64) = [] of Int64
    property stars : Float64
    @[JSON::Field(key: "numVotes")]
    property num_votes : Int64
    property type : String
    property fa : String
    @[JSON::Field(key: "ratingRock")]
    property rating_rock : Int64
    @[JSON::Field(key: "ratingBoulder")]
    property rating_boulder : Int64
    @[JSON::Field(key: "ratingIce")]
    property rating_ice : Int64
    @[JSON::Field(key: "ratingMixed")]
    property rating_mixed : Int64
    @[JSON::Field(key: "ratingAid")]
    property rating_aid : Int64
    @[JSON::Field(key: "ratingSnow")]
    property rating_snow : Int64
    @[JSON::Field(key: "ratingSafety")]
    property rating_safety : String
    property grade : String
    property height : Int64
    property popularity : Int64
    property first_photo : Photo?

    class Photo
      include JSON::Serializable

      property id : Int64
      property text : String
      @[JSON::Field(key: "userId")]
      property user_id : Int64
      @[JSON::Field(key: "scoreAvg")]
      property score_avg : Int64
      @[JSON::Field(key: "scoreCount")]
      property score_count : Int64
      property sizes : Sizes

      class Sizes
        include JSON::Serializable

        property thumb : Thumb
        property medium : Medium

        class Thumb
          include JSON::Serializable

          property url : String
          property w : Int64
          property h : Int64
        end

        class Medium
          include JSON::Serializable

          property url : String
          property w : Int64
          property h : Int64
        end
      end
    end
  end

  class Rating
    include JSON::Serializable

    property id : Int64
    @[JSON::Field(key: "userId")]
    property user_id : Int64
    @[JSON::Field(key: "userRating")]
    property user_rating : String | UserRating
    property date : Int64
    property comment : String

    class UserRating
      include JSON::Serializable

      property id : Int64
      property rock : Int64
      property ice : Int64
      property mixed : Int64
      property aid : Int64
      property boulder : Int64
      property snow : Int64
      property safety : String
      property score : Int64
    end
  end

  class AccessNote
    include JSON::Serializable

    property id : Int64
    property note : String
    property details : String
  end

  class Metadata
    include JSON::Serializable

    property title : String
    property body : String
  end

  class User
    include JSON::Serializable

    property id : Int64
    property first : String
    property last : String
    property avatar : String
  end

  class Trail
    include JSON::Serializable

    property id : Int64
    property title : String
    property description : String
    property length : Float64
    property ascent : Float64
    property descent : Float64
    property points : String
  end
end
