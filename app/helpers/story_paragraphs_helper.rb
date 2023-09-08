module StoryParagraphsHelper
  def render_excerpt(sp)
    raise 'Wrong object' unless sp.is_a? StoryParagraph

    link_to "#{sp.story_index} #{sp.flag} #{sp.original_text.first(30)}..", sp
  end

  def render_mp3_button(sp, opts={})
    # https://edgeguides.rubyonrails.org/active_storage_overview.html#attaching-files-to-records
    file = sp.mp3_audio
    opts_autoplay = opts.fetch(:autoplay, false)
    opts_muted = opts.fetch( :muted, false)
    autoplay_str = opts_autoplay ? 'autoplay' : ''
    muted_str = opts_muted ? 'muted' : ''
    if sp.mp3_audio.attached?
      #return #content_tag('a',  class: "btn btn-outline-success")
      #'<button type="button" class="btn btn-outline-success">🎶 Play</button>'.html_safe
      #ret = link_to '🎶 Play me', rails_blob_path(file, disposition: "attachment") , class: "btn btn-outline-success"
      #ret += '<audio src="'+rails_blob_path(file, type: "audio")+'" type="audio/mpeg" controls> Your browser does not support the audio element. </audio>'

      # Note: Note: Chromium browsers do not allow autoplay in most cases. However, muted autoplay is always allowed.

      # DEF aps/mu=#{autoplay_str}/#{muted_str}
      # playbackRate DOESNT WORK try: playbackRate='1.5'
      ret = "<audio controls #{autoplay_str} #{muted_str}  src='#{ rails_blob_path(sp.mp3_audio, type: "audio") rescue nil }' type='audio/mpeg' >
          Your browser does not support the audio element.
        </audio>"
      ret.html_safe
    else
      return '🔕'
    end
  end
end
