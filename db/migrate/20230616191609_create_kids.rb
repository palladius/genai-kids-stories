class CreateKids < ActiveRecord::Migration[7.0]
  def change
    create_table :kids do |t|
      t.string :name
      t.string :surname
      t.string :nick
      t.string :visual_description
      t.boolean :is_male
      t.date :date_of_birth
      t.text :internal_info
      t.integer :user_id

      t.timestamps
    end
  end
end
