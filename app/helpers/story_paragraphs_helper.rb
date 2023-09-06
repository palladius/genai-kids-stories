module StoryParagraphsHelper
  def render_excerpt(sp)
    raise 'Wrong object' unless sp.is_a? StoryParagraph

    link_to "#{sp.story_index} #{sp.flag} #{sp.original_text.first(30)}..", sp
  end

  def render_mp3_button(sp)
    # https://edgeguides.rubyonrails.org/active_storage_overview.html#attaching-files-to-records
    file = sp.mp3_audio
    if sp.mp3_audio.attached?
      #return #content_tag('a',  class: "btn btn-outline-success")
      #'<button type="button" class="btn btn-outline-success">🎶 Play</button>'.html_safe
      #ret = link_to '🎶 Play me', rails_blob_path(file, disposition: "attachment") , class: "btn btn-outline-success"
      #ret += '<audio src="'+rails_blob_path(file, type: "audio")+'" type="audio/mpeg" controls> Your browser does not support the audio element. </audio>'
      ret = "<audio controls src='#{ rails_blob_path(sp.mp3_audio, type: "audio") rescue nil }' type='audio/mpeg' controls>
          Your browser does not support the audio element.
        </audio>"
      ret.html_safe
    else
      return ''
    end
  end
end
