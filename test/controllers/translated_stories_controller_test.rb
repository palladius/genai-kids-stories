require "test_helper"

class TranslatedStoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @translated_story = translated_stories(:one)
  end

  test "should get index" do
    get translated_stories_url
    assert_response :success
  end

  test "should get new" do
    get new_translated_story_url
    assert_response :success
  end

  test "should create translated_story" do
    assert_difference("TranslatedStory.count") do
      post translated_stories_url, params: { translated_story: { client_id: @translated_story.client_id, genai_model: @translated_story.genai_model, internal_notes: @translated_story.internal_notes, language: @translated_story.language, name: @translated_story.name, paragraph_strategy: @translated_story.paragraph_strategy, story_id: @translated_story.story_id, user_id: @translated_story.user_id } }
    end

    assert_redirected_to translated_story_url(TranslatedStory.last)
  end

  test "should show translated_story" do
    get translated_story_url(@translated_story)
    assert_response :success
  end

  test "should get edit" do
    get edit_translated_story_url(@translated_story)
    assert_response :success
  end

  test "should update translated_story" do
    patch translated_story_url(@translated_story), params: { translated_story: { client_id: @translated_story.client_id, genai_model: @translated_story.genai_model, internal_notes: @translated_story.internal_notes, language: @translated_story.language, name: @translated_story.name, paragraph_strategy: @translated_story.paragraph_strategy, story_id: @translated_story.story_id, user_id: @translated_story.user_id } }
    assert_redirected_to translated_story_url(@translated_story)
  end

  test "should destroy translated_story" do
    assert_difference("TranslatedStory.count", -1) do
      delete translated_story_url(@translated_story)
    end

    assert_redirected_to translated_stories_url
  end
end
