module StoriesHelper

  def render_story(story)
    if story.is_a?( Story)
      input_size =story.genai_input.size
      output_size =story.genai_output.size
      arr = [
        link_to( "##{story.id}", story),
        link_to(story.title, story),
        link_to(story.kid,story.kid),
        #story.avatar.to_s.gsub('<', '&lt;').gsub('>', '&gt;'), # image_tag(story.avatar.variant(:thumb)),
        (image_tag(story.cover_image, height: 100) rescue $! ),
        "#{input_size} / #{output_size}"
      ]
      ret = arr.map{|el| "<td>#{el}</td>" }.join("\n")
    else
      arr = [
        'opts',
        'Title',
        'Kid',
        'cover_image',
        'I/O size',
      ]
      ret = arr.map{|el| "<th>#{el}</th>" }.join("\n")
    end

      ret.html_safe
  end

end
