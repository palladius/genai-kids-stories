require "test_helper"

class StoryTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story_template = story_templates(:one)
  end

  test "should get index" do
    get story_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_story_template_url
    assert_response :success
  end

  test "should create story_template" do
    assert_difference("StoryTemplate.count") do
      post story_templates_url, params: { story_template: { description: @story_template.description, internal_notes: @story_template.internal_notes, short_code: @story_template.short_code, template: @story_template.template, user_id: @story_template.user_id } }
    end

    assert_redirected_to story_template_url(StoryTemplate.last)
  end

  test "should show story_template" do
    get story_template_url(@story_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_story_template_url(@story_template)
    assert_response :success
  end

  test "should update story_template" do
    patch story_template_url(@story_template), params: { story_template: { description: @story_template.description, internal_notes: @story_template.internal_notes, short_code: @story_template.short_code, template: @story_template.template, user_id: @story_template.user_id } }
    assert_redirected_to story_template_url(@story_template)
  end

  test "should destroy story_template" do
    assert_difference("StoryTemplate.count", -1) do
      delete story_template_url(@story_template)
    end

    assert_redirected_to story_templates_url
  end
end
