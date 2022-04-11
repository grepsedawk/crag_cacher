class MountainProject::Routes::ShowPage < AuthLayout
  needs route : MountainProject::Route

  def content
    div do
      raw Markd.to_html route.breadcrumbs
    end
    h1 route.name
    div route.rating
    div route.type
    div do
      text "First ascent: "
      text route.first_ascent
    end
    h2 "Description"
    div do
      raw Markd.to_html route.description
    end

    h2 "Protection"
    div do
      raw Markd.to_html route.protection
    end

    h2 "Photos"
    div class: "container grid grid-cols-3 gap-2 mx-auto" do
      route.photos.each do |photo|
        photo.url.try do |url|
          img src: url
        end
      end
    end
  end
end
