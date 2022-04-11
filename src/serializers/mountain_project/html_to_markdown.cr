module MountainProject::HtmlToMarkdown
  def self.convert(node)
    node.children.map do |child|
      case child.tag_sym
      when :a
        "[#{convert(child)}](#{converted_url(child.attributes["href"]?)})"
      when :img
        "![#{child.attributes["alt"]?}](#{child.attributes["src"]})"
      when :_text
        child.tag_text.strip
      when :br
        "\n"
      when :div
        convert(child) + "\n\n"
      when :p
        convert(child) + "\n\n"
      else
        child.inner_text.strip
      end
    end.join(" ").strip
  end

  def self.converted_url(url)
    url.try &.match(%r{(/\w+/\d+\S*)}).try &.[0]
      .gsub("area", "mountain_project/areas")
      .gsub("route", "mountain_project/routes")
  end
end
