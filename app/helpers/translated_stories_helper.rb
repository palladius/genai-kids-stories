module TranslatedStoriesHelper
  # <table border="0" >

  # #{ @story_paragraphs.each do |p| }

  # #{ end }
  # </table>

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
end
