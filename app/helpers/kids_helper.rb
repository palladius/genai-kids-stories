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

  # use the view instead
  def render_bootstrap_kid_obsolete(kid)
    return '' unless kid.is_a?(Kid)

    avatar = kid.avatar.attached? ? image_tag(kid.avatar, height: 70) : '-'
    # <img src=\"...\" class=\"card-img-top\" alt=\"...\">

    title = link_to(kid.nick, kid)
    subtitle = "##{kid.id} #{kid.flag} #{time_ago_in_words(kid.date_of_birth)}"
    description = kid.visual_description
    destroy_button_too_dangerous = button_to('💣', kid, class: 'btn btn-secondary', method: :delete)

    # <%= link_to "Edit this kid", edit_kid_path(@kid) %> |
    # <%= link_to "Back to kids", kids_path %>

    # <%= button_to "Destroy this kid", @kid, method: :delete %>

    "<div class=\"card\" style=\"width: 18rem;\">
    #{avatar}
    <div class=\"card-body\">
      <h5 class=\"card-title\">#{title}</h5>
      <h6 class=\"card-subtitle mb-2 text-body-secondary\">#{subtitle}</h6>
      <p class=\"card-text\">#{description}</p>
      #{link_to('show', kid, class: 'btn btn-primary')}
      #{link_to('edit', edit_kid_path(kid), class: 'btn btn-secondary')}
    </div>
  </div>".html_safe
  end
end
