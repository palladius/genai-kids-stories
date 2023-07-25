module StoryTemplatesHelper

  def render_colored_story_template_template(story_template)
    #.bg-warning
    #        <%= raw( p.translated_text.gsub(/\*\*(A.* [1-5])\*\*/) { "<span class='act15' ><b><u>#{Regexp.last_match(1)}</u></b></span><br/><br/>" }.gsub('**','') )%>

    return content_tag :tt, story_template.template.gsub(/{{(\w+)}}/) {
      "<span class='act15 bg-warning' ><b>{{#{Regexp.last_match(1)}}}</b></span>"
    }.gsub("\n", "<br/>\n").html_safe
    #'sobenme')
    #"AAA #{story_template.template}"
  end

end
