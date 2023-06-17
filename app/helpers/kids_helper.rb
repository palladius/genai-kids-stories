module KidsHelper

  def render_kid(kid)
    if kid.is_a?( Kid)
      arr = [
        link_to( "##{kid.id} #{kid.nick}", kid),
        kid.date_of_birth,
        kid.visual_description,
        kid.avatar.to_s.gsub('<', '&lt;').gsub('>', '&gt;'), # image_tag(kid.avatar.variant(:thumb)),
        (image_tag(kid.avatar, height: 50) rescue '' ),
      ]
      ret = arr.map{|el| "<td>#{el}</td>" }.join("\n")
    else
      arr = [
        'opts',
        'DOB',
        'visual_description',
        'avatar'
      ]
      ret = arr.map{|el| "<th>#{el}</th>" }.join("\n")
    end

      ret.html_safe
  end
end
