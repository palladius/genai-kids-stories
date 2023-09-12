class AddInterestsToKid < ActiveRecord::Migration[7.0]
  def change
    add_column :kids, :interests, :text
  end
end
