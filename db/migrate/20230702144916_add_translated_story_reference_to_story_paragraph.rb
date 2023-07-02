class AddTranslatedStoryReferenceToStoryParagraph < ActiveRecord::Migration[7.0]
  def change
    # ideally...
    # add_reference :story_paragraphs, :translated_story, null: false, foreign_key: true
    # but i have to fix it first and to fix it i need to create it :)
    add_reference :story_paragraphs, :translated_story, foreign_key: true
  end
end
