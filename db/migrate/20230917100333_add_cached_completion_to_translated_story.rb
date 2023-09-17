class AddCachedCompletionToTranslatedStory < ActiveRecord::Migration[7.0]
  def change
    add_column :translated_stories, :cached_completion, :float, default: -1
    TranslatedStory.all.each{|ts| ts.update_cache }
  end
end
