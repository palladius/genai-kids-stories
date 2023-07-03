class AddTranslatedTitleToTranslatedStory < ActiveRecord::Migration[7.0]
  def change
    add_column :translated_stories, :translated_title, :string
  end
end
