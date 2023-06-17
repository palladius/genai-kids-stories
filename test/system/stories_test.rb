require "application_system_test_case"

class StoriesTest < ApplicationSystemTestCase
  setup do
    @story = stories(:one)
  end

  test "visiting the index" do
    visit stories_url
    assert_selector "h1", text: "Stories"
  end

  test "should create story" do
    visit stories_url
    click_on "New story"

    fill_in "Genai input", with: @story.genai_input
    fill_in "Genai output", with: @story.genai_output
    fill_in "Genai summary", with: @story.genai_summary
    fill_in "Internal notes", with: @story.internal_notes
    fill_in "Kid", with: @story.kid_id
    fill_in "Title", with: @story.title
    fill_in "User", with: @story.user_id
    click_on "Create Story"

    assert_text "Story was successfully created"
    click_on "Back"
  end

  test "should update Story" do
    visit story_url(@story)
    click_on "Edit this story", match: :first

    fill_in "Genai input", with: @story.genai_input
    fill_in "Genai output", with: @story.genai_output
    fill_in "Genai summary", with: @story.genai_summary
    fill_in "Internal notes", with: @story.internal_notes
    fill_in "Kid", with: @story.kid_id
    fill_in "Title", with: @story.title
    fill_in "User", with: @story.user_id
    click_on "Update Story"

    assert_text "Story was successfully updated"
    click_on "Back"
  end

  test "should destroy Story" do
    visit story_url(@story)
    click_on "Destroy this story", match: :first

    assert_text "Story was successfully destroyed"
  end
end
