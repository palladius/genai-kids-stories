# RicUtils v1.0

# colors
def yellow(s)
  "\033[1;33m#{s}\033[0m"
end

def white(s)
  "\033[1;33m#{s}\033[0m"
end

def blue(s)
  "\033[1;34m#{s}\033[0m"
end

# Content which goes into API call needs to be removed of quotes, double quotes and asterisks.
def cleaned_up_content(content)
  content.gsub(/"/, '').gsub(/\n/, ' ').gsub(/\*/, '') # remove quotes.. seems to give error, eg in this sentence:
end

# StoryParagraph.all.map{|x| [x.id, x.internal_notes, x.story.id, x.translated_my_story_id]}
def big_migration
  problematic_story_ids = StoryParagraph.where(translated_story_id: nil).map { |x| x.story.id }.uniq

  problematic_story_ids.each do |my_story_id|
    puts "Step 1. Generate the Translated Story for Story.id=#{my_story_id}"
    ts = Story.find(my_story_id).generate_migration_translated_story
    raise "Not a TS! #{ts.class}" unless ts.is_a?(TranslatedStory)

    puts "Step 2. Patch all SP with translated_my_story_id=nil and Story.id=#{my_story_id}"
    StoryParagraph.where(story_id: my_story_id, translated_story_id: nil).each do |sp|
      sp.translated_story_id = ts.id
      puts("SP valid? #{sp.valid?}")
      ret = sp.save
      puts(sp.errors.full_messages) unless ret # oK!
    end
  end

end

def ai_test()
  puts(blue "This is a test to check that GCP is enabled and your service account works. Usually the auth token expires every 1h so its nice to have a quick check before running the app.")
  @magic_content = 'Can you explain why the sky is blue?'
  puts("Asking Palm API: #{yellow @magic_content}")
  #extend Genai::AiplatformTextCurl
  include Genai::AiplatformTextCurl
  genai_markdown = ai_curl_by_content(@magic_content)[1] rescue "💔 Some Error in generation: **#{$!}**. Should have made up a story around: \n###MagicContent\n\n *'#{@magic_content}'*"
  puts(yellow genai_markdown)
  return :uttobbene
end

# This is the big migration from SParagraphs attached to stories (which is wrong as i can only translate each story in a single language)
# to SParagraphs attached to translated_stories. Difference?
# $ StoryParagraph.all.map{|x| [x.id, x.internal_notes, x.story.id, x.translated_story_id]}
# [155, "Created via Story.generate_paragraphs on 2023-06-30 21:42:47 +0200\n", 2026, nil],
# [156, "Created via Story.generate_paragraphs on 2023-06-30 21:43:03 +0200\n", 2026, nil],
# [157, "Created via Story.generate_paragraphs on 2023-06-30 21:43:18 +0200\n", 2026, nil],
# [158, "Created via Story.generate_paragraphs on 2023-06-30 21:43:34 +0200\n", 2026, nil],
# [159, "Created via Story.generate_paragraphs on 2023-06-30 21:43:49 +0200\n", 2026, nil],
# [160, "Created via Story.generate_paragraphs on 2023-06-30 21:44:05 +0200\n", 2026, nil],
# [161, "Created via Story.generate_paragraphs on 2023-07-02 10:33:57 +0200\n", 2028, nil],
# [162, "Created via Story.generate_paragraphs on 2023-07-02 10:34:13 +0200\n", 2028, nil],
# [163, "Created via Story.generate_paragraphs on 2023-07-02 10:34:28 +0200\n", 2028, nil],
# [164, "Created via Story.generate_paragraphs on 2023-07-02 10:34:44 +0200\n", 2028, nil],
# [165, "Created via Story.generate_paragraphs on 2023-07-02 10:34:58 +0200\n", 2028, nil],
# [166, "Created via Story.generate_paragraphs on 2023-07-02 10:35:13 +0200\n", 2028, nil],
# [167, "Created via Story.generate_paragraphs on 2023-07-02 10:35:28 +0200\n", 2028, nil],
# [168, "Created via Story.generate_paragraphs on 2023-07-02 10:35:42 +0200\n", 2028, nil],
# [169, "Created via Story.generate_paragraphs on 2023-07-03 10:37:42 +0200\n", 2030, 13],
# [170, "Created via Story.generate_paragraphs on 2023-07-03 10:37:57 +0200\n", 2030, 13],
# [171, "Created via Story.generate_paragraphs on 2023-07-03 10:38:16 +0200\n", 2030, 13],
# [172, "Created via Story.generate_paragraphs on 2023-07-03 10:38:35 +0200\n", 2030, 13],
# [173, "Created via Story.generate_paragraphs on 2023-07-03 10:38:54 +0200\n", 2030, 13],
# [174, "Created via Story.generate_paragraphs on 2023-07-03 10:39:13 +0200\n", 2030, 13],
# [175, "Created via Story.generate_paragraphs on 2023-07-03 10:39:32 +0200\n", 2030, 13],
# [176, "Created via Story.generate_paragraphs on 2023-07-03 10:39:51 +0200\n", 2030, 13],
# [177, "Created via Story.generate_paragraphs on 2023-07-03 10:40:10 +0200\n", 2030, 13],
# [178, "Created via Story.generate_paragraphs on 2023-07-03 10:40:29 +0200\n", 2030, 13],
# [179, "Created via Story.generate_paragraphs on 2023-07-03 10:40:48 +0200\n", 2030, 13],
# [180, "Created via TranslatedStory.generate_polymorphic_paragraphs on 2023-07-03 21:12:49 +0200\n", 2030, 16],
# [181, "Created via TranslatedStory.generate_polymorphic_paragraphs on 2023-07-03 21:13:07 +0200\n", 2030, 16],
# [182, "Created via TranslatedStory.generate_polymorphic_paragraphs on 2023-07-03 21:13:29 +0200\n", 2030, 16],
# [183, "Created via TranslatedStory.generate_polymorphic_paragraphs on 2023-07-03 21:13:50 +0200\n", 2030, 16],
# [184, "Created via TranslatedStory.generate_polymorphic_paragraphs on 2023-07-03 21:14:10 +0200\n", 2030, 16],
