require "application_system_test_case"

class StoryParagraphsTest < ApplicationSystemTestCase
  setup do
    @story_paragraph = story_paragraphs(:one)
  end

  test "visiting the index" do
    visit story_paragraphs_url
    assert_selector "h1", text: "Story paragraphs"
  end

  test "should create story paragraph" do
    visit story_paragraphs_url
    click_on "New story paragraph"

    fill_in "Genai input for image", with: @story_paragraph.genai_input_for_image
    fill_in "Internal notes", with: @story_paragraph.internal_notes
    fill_in "Language", with: @story_paragraph.language
    fill_in "Original text", with: @story_paragraph.original_text
    fill_in "Rating", with: @story_paragraph.rating
    fill_in "Story", with: @story_paragraph.story_id
    fill_in "Story index", with: @story_paragraph.story_index
    fill_in "Translated text", with: @story_paragraph.translated_text
    click_on "Create Story paragraph"

    assert_text "Story paragraph was successfully created"
    click_on "Back"
  end

  test "should update Story paragraph" do
    visit story_paragraph_url(@story_paragraph)
    click_on "Edit this story paragraph", match: :first

    fill_in "Genai input for image", with: @story_paragraph.genai_input_for_image
    fill_in "Internal notes", with: @story_paragraph.internal_notes
    fill_in "Language", with: @story_paragraph.language
    fill_in "Original text", with: @story_paragraph.original_text
    fill_in "Rating", with: @story_paragraph.rating
    fill_in "Story", with: @story_paragraph.story_id
    fill_in "Story index", with: @story_paragraph.story_index
    fill_in "Translated text", with: @story_paragraph.translated_text
    click_on "Update Story paragraph"

    assert_text "Story paragraph was successfully updated"
    click_on "Back"
  end

  test "should destroy Story paragraph" do
    visit story_paragraph_url(@story_paragraph)
    click_on "Destroy this story paragraph", match: :first

    assert_text "Story paragraph was successfully destroyed"
  end
end
