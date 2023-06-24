module StoryParagraphsHelper
  def render_excerpt(sp)
    raise 'Wrong object' unless sp.is_a? StoryParagraph

    link_to "#{sp.story_index} #{sp.flag} #{sp.original_text.first(30)}..", sp
  end
end
