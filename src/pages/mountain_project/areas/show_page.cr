class MountainProject::Areas::ShowPage < AuthLayout
  needs area : MountainProject::Area

  def content
    div do
      raw Markd.to_html area.breadcrumbs
    end

    h1 area.name

    h2 "Areas"
    ul do
      area.areas.each do |area|
        li do
          a area.name, href: "/mountain_project/areas/#{area.id}"
        end
      end
    end

    h2 "Routes"
    ul do
      area.routes.each do |route|
        li do
          a route.name, href: "/mountain_project/routes/#{route.id}"
        end
      end
    end
  end
end
