class AddFavoriteLangugageToKid < ActiveRecord::Migration[7.0]
  def change
    add_column :kids, :favorite_language, :string
  end
end
