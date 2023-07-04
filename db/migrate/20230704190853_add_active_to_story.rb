class AddActiveToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :active, :boolean, default: true
    add_column :kids, :active, :boolean, default: true
    # Also consider change_column_default - https://stackoverflow.com/questions/7098602/add-a-default-value-to-a-column-through-a-migration
  end
end
