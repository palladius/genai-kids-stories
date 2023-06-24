class CreateStoryParagraphs < ActiveRecord::Migration[7.0]
  def change
    create_table :story_paragraphs do |t|
      t.integer :story_index
      t.text :original_text
      t.text :genai_input_for_image
      t.text :internal_notes
      t.text :translated_text
      t.string :language
      # t.references :story, null: false, foreign_key: true
      t.references :story, null: false, index: true, foreign_key: { on_delete: :cascade }
      #  t.references :parent, index: true, foreign_key: {on_delete: :cascade}

      t.integer :rating

      t.timestamps
    end
  end
end
