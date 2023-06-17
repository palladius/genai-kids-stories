class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.text :genai_input
      t.text :genai_output
      t.text :genai_summary
      t.text :internal_notes
      t.integer :user_id
      t.references :kid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
