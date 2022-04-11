class MountainProject::Areas::ShowPage < AuthLayout
  needs area : MountainProject::Area

  def content
    div do
      raw Markd.to_html area.breadcrumbs
    end

    h1 area.name

    unless area.access_notes.empty?
      details do
        summary "IMPORTANT: Access Notes"
        raw Markd.to_html area.access_notes
      end
    end

    unless area.areas.empty?
      h2 "Areas"
      ul do
        area.areas.each do |area|
          li do
            a area.name, href: "/mountain_project/areas/#{area.id}"
          end
        end
      end
    end

    unless area.routes.empty?
      h2 "Routes"
      ul do
        area.routes.each do |route|
          li do
            a route.name, href: "/mountain_project/routes/#{route.id}"
          end
        end
      end
    end

    h2 "Photos"
    div class: "container grid grid-cols-3 gap-2 mx-auto" do
      area.photos.each do |photo|
        photo.url.try do |url|
          img src: url
        end
      end
    end
  end
end
