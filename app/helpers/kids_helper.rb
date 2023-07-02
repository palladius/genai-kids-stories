module KidsHelper
  def render_kid(kid)
    if kid.is_a?(Kid)
      avatar = kid.avatar.attached? ? image_tag(kid.avatar, height: 70) : '-'
      arr = [
        link_to("##{kid.id} #{kid.nick}", kid),
        kid.date_of_birth,
        "<b>#{kid.favorite_language}</b>", # TODO: flag
        kid.visual_description,
        # kid.avatar.to_s.gsub('<', '&lt;').gsub('>', '&gt;'), # image_tag(kid.avatar.variant(:thumb)),
        avatar
      ]
      ret = arr.map { |el| "<td>#{el}</td>" }.join("\n")
    else
      arr = %w[
        opts
        DOB
        lang
        visual_description
        avatar
      ]
      ret = arr.map { |el| "<th>#{el}</th>" }.join("\n")
    end

    ret.html_safe
  end
end
