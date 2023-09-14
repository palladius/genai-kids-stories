class AddInterestsToKid < ActiveRecord::Migration[7.0]
  def change
    add_column :kids, :interests, :text
    # TODO Add migration which does just this: TranslatedStory.update_cache_for_all!
  end
end
