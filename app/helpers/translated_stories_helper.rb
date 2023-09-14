module TranslatedStoriesHelper
  # <table border="0" >

  # #{ @story_paragraphs.each do |p| }

  # #{ end }
  # </table>
  #
  #
  # INPUT: [[1, 348, true], [2, 349, false], [3, 350, true], [4, 351, false], [5, 352, false], [6, 353, false], [7, 354, true]]
  # OUTPUT:
  def render_cached_info(ts, symbolic_method, opts={})
    opts_verbose = opts.fetch :verbose, false
    return :TODO if opts_verbose

    ts_generic_array = ts.send(symbolic_method) # Gets array like
    emoji_nope = '❌'
    emoji_yup = case symbolic_method
      when :cache_audios
        '🎶' # missing audio could be: 🔕 (awesome)
      when :cache_images
        '🏞️' # missing image could be: 🌌 (meh)
      else
        'unrecognize'
      end
      content_tag 'tt', (ts_generic_array.map{|x| x[2] ? emoji_yup : emoji_nope}.join '') rescue '🤷🏼‍♀️'
  end

  def render_working_story_paragraph(p)
    if p.nil?
      return '<tr>
        <th>IX
        <th>Original 🇬🇧
        <th>Lang / Pic
        <th>Translated
        <th>Opts
      </tr>'.html_safe
    end
    "<tr>
      <td>#{link_to p.story_index, p}🔷
      <td width='45%' class='story' >#{p.original_text}
      <td>
        #{p.flag}
        #{render_image_if_attached(p.p_image1, verbose: false)}

      <td width='45%' class='story' >#{p.translated_text or "<pre>StoryParagraph.find(#{p.id}).after_creation_magic</pre>".html_safe}
      <td>
          #{link_to p.id, p}
          #{link_to '✍🏿', edit_story_paragraph_path(p)}
         ".html_safe
  end

  def render_completion_pct(translated_story)
    pct = translated_story.completion_pct
    style = (pct == 0) ? 'bg-secondary' : 'bg-success'
    pct ?
      "<kbd class='#{style}' >#{pct.to_s.rjust(2,'0')}</kbd>".html_safe :
      '-'
  end

end
