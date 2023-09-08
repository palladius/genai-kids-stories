class AddScoreAndInternalSettingsToStories < ActiveRecord::Migration[7.0]
  def change
    # Will use https://api.rubyonrails.org/classes/ActiveRecord/Store.html
    # To Stories
    add_column :stories, :score, :integer, default: 0
    add_column :stories, :settings, :text
    # To translated_stories
    add_column :translated_stories, :score, :integer, default: 0
    add_column :translated_stories, :settings, :text
  end
end
