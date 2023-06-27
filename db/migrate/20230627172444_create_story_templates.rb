class CreateStoryTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :story_templates do |t|
      t.string :short_code
      t.string :description
      t.text :template
      t.text :internal_notes
      t.integer :user_id

      t.timestamps
    end
  end
end
