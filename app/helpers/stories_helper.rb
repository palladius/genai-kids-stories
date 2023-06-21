module StoriesHelper

  def render_story_title(story)
    (story.title.size rescue 0) > 3 ? story.title : '🚧 Not available yet2 🚧'
  end

  def render_story(story)
    if story.is_a?( Story)
      input_size =story.genai_input.size rescue 0
      output_size =story.genai_output.size rescue 0
      three_buttons = ''
        three_buttons << link_to( "✅#{story.id}", story)
        three_buttons << link_to( "📝", edit_story_path(story))
        three_buttons << (button_to "💣", story, method: :delete )
      title = render_story_title(story)
      arr = [
        three_buttons.html_safe,
        link_to(story.kid.nick,story.kid),
        link_to( title , story),
        #story.avatar.to_s.gsub('<', '&lt;').gsub('>', '&gt;'), # image_tag(story.avatar.variant(:thumb)),
        (image_tag(story.cover_image, height: 100) rescue '' ),
        "#{input_size} / #{output_size}"
      ]
      ret = arr.map{|el| "<td>#{el}</td>" }.join("\n")
    else
      arr = [
        'opts',
        'Kid',
        'Title',
        'cover_image',
        'I/O size',
      ]
      ret = arr.map{|el| "<th>#{el}</th>" }.join("\n")
    end

      ret.html_safe
  end

end
