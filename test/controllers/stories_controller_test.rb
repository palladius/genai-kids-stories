require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = stories(:one)
  end

  test "should get index" do
    get stories_url
    assert_response :success
  end

  test "should get new" do
    get new_story_url
    assert_response :success
  end

  test "should create story" do
    assert_difference("Story.count") do
      post stories_url, params: { story: { genai_input: @story.genai_input, genai_output: @story.genai_output, genai_summary: @story.genai_summary, internal_notes: @story.internal_notes, kid_id: @story.kid_id, title: @story.title, user_id: @story.user_id } }
    end

    assert_redirected_to story_url(Story.last)
  end

  test "should show story" do
    get story_url(@story)
    assert_response :success
  end

  test "should get edit" do
    get edit_story_url(@story)
    assert_response :success
  end

  test "should update story" do
    patch story_url(@story), params: { story: { genai_input: @story.genai_input, genai_output: @story.genai_output, genai_summary: @story.genai_summary, internal_notes: @story.internal_notes, kid_id: @story.kid_id, title: @story.title, user_id: @story.user_id } }
    assert_redirected_to story_url(@story)
  end

  test "should destroy story" do
    assert_difference("Story.count", -1) do
      delete story_url(@story)
    end

    assert_redirected_to stories_url
  end
end
