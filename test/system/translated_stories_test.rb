require "application_system_test_case"

class TranslatedStoriesTest < ApplicationSystemTestCase
  setup do
    @translated_story = translated_stories(:one)
  end

  test "visiting the index" do
    visit translated_stories_url
    assert_selector "h1", text: "Translated stories"
  end

  test "should create translated story" do
    visit translated_stories_url
    click_on "New translated story"

    fill_in "Client", with: @translated_story.client_id
    fill_in "Genai model", with: @translated_story.genai_model
    fill_in "Internal notes", with: @translated_story.internal_notes
    fill_in "Language", with: @translated_story.language
    fill_in "Name", with: @translated_story.name
    fill_in "Paragraph strategy", with: @translated_story.paragraph_strategy
    fill_in "Story", with: @translated_story.story_id
    fill_in "User", with: @translated_story.user_id
    click_on "Create Translated story"

    assert_text "Translated story was successfully created"
    click_on "Back"
  end

  test "should update Translated story" do
    visit translated_story_url(@translated_story)
    click_on "Edit this translated story", match: :first

    fill_in "Client", with: @translated_story.client_id
    fill_in "Genai model", with: @translated_story.genai_model
    fill_in "Internal notes", with: @translated_story.internal_notes
    fill_in "Language", with: @translated_story.language
    fill_in "Name", with: @translated_story.name
    fill_in "Paragraph strategy", with: @translated_story.paragraph_strategy
    fill_in "Story", with: @translated_story.story_id
    fill_in "User", with: @translated_story.user_id
    click_on "Update Translated story"

    assert_text "Translated story was successfully updated"
    click_on "Back"
  end

  test "should destroy Translated story" do
    visit translated_story_url(@translated_story)
    click_on "Destroy this translated story", match: :first

    assert_text "Translated story was successfully destroyed"
  end
end
