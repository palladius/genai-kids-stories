module StoriesHelper
  def render_story_title(story)
    if begin
      story.title.size
    rescue StandardError
      0
    end > 3
      story.title
    else
      '🚧 Not available yet2 🚧'
    end
  end

  def render_story(story)
    if story.is_a?(Story)
      input_size = begin
        story.genai_input.size
      rescue StandardError
        0
      end
      output_size = begin
        story.genai_output.size
      rescue StandardError
        0
      end
      three_buttons = ''
      three_buttons << link_to("✅#{story.id}", story)
      three_buttons << link_to('📝', edit_story_path(story))
      three_buttons << (button_to '💣', story, method: :delete)
      title = render_story_title(story)
      arr = [
        three_buttons.html_safe,
        link_to(story.kid.nick, story.kid),
        link_to(title, story),
        begin
          image_tag(story.cover_image, height: 100)
        rescue StandardError
          ''
        end

      ]
      ret = arr.map { |el| "<td>#{el}</td>" }.join("\n")
    else
      arr = [
        'opts',
        'Kid',
        'Title',
        'cover_image',
        'I/O size'
      ]
      ret = arr.map { |el| "<th>#{el}</th>" }.join("\n")
    end

    ret.html_safe
  end
end
