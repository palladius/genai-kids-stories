module StoriesHelper

  def render_story(story)
    if story.is_a?( Story)
      arr = [
        link_to( "##{story.id}", story),
        story.title,
        link_to(story.kid,story.kid),
        #story.avatar.to_s.gsub('<', '&lt;').gsub('>', '&gt;'), # image_tag(story.avatar.variant(:thumb)),
        (image_tag(story.cover_image, height: 100) rescue $! ),
      ]
      ret = arr.map{|el| "<td>#{el}</td>" }.join("\n")
    else
      arr = [
        'opts',
        'Title',
        'Kid',
        'cover_image'
      ]
      ret = arr.map{|el| "<th>#{el}</th>" }.join("\n")
    end

      ret.html_safe
  end

end
