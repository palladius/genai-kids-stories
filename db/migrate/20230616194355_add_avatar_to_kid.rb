class AddAvatarToKid < ActiveRecord::Migration[7.0]
  def change
    add_column :kids, :avatar, :attachment
  end

  # self.up
  #   add_column :kids, :avatar, :attachment
  # end

  # self.down
  #   remove_column :kids, :avatar
  # end

end
