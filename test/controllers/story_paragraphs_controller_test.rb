require "test_helper"

class StoryParagraphsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story_paragraph = story_paragraphs(:one)
  end

  test "should get index" do
    get story_paragraphs_url
    assert_response :success
  end

  test "should get new" do
    get new_story_paragraph_url
    assert_response :success
  end

  test "should create story_paragraph" do
    assert_difference("StoryParagraph.count") do
      post story_paragraphs_url, params: { story_paragraph: { genai_input_for_image: @story_paragraph.genai_input_for_image, internal_notes: @story_paragraph.internal_notes, language: @story_paragraph.language, original_text: @story_paragraph.original_text, rating: @story_paragraph.rating, story_id: @story_paragraph.story_id, story_index: @story_paragraph.story_index, translated_text: @story_paragraph.translated_text } }
    end

    assert_redirected_to story_paragraph_url(StoryParagraph.last)
  end

  test "should show story_paragraph" do
    get story_paragraph_url(@story_paragraph)
    assert_response :success
  end

  test "should get edit" do
    get edit_story_paragraph_url(@story_paragraph)
    assert_response :success
  end

  test "should update story_paragraph" do
    patch story_paragraph_url(@story_paragraph), params: { story_paragraph: { genai_input_for_image: @story_paragraph.genai_input_for_image, internal_notes: @story_paragraph.internal_notes, language: @story_paragraph.language, original_text: @story_paragraph.original_text, rating: @story_paragraph.rating, story_id: @story_paragraph.story_id, story_index: @story_paragraph.story_index, translated_text: @story_paragraph.translated_text } }
    assert_redirected_to story_paragraph_url(@story_paragraph)
  end

  test "should destroy story_paragraph" do
    assert_difference("StoryParagraph.count", -1) do
      delete story_paragraph_url(@story_paragraph)
    end

    assert_redirected_to story_paragraphs_url
  end
end
