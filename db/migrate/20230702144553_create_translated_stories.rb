class CreateTranslatedStories < ActiveRecord::Migration[7.0]
  def change
    create_table :translated_stories do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.references :story, null: false, foreign_key: true
      t.string :language
      t.integer :kid_id
      t.string :paragraph_strategy
      t.text :internal_notes
      t.string :genai_model

      t.timestamps
    end
    add_index :translated_stories, :kid_id
  end
end
