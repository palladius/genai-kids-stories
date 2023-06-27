require "application_system_test_case"

class StoryTemplatesTest < ApplicationSystemTestCase
  setup do
    @story_template = story_templates(:one)
  end

  test "visiting the index" do
    visit story_templates_url
    assert_selector "h1", text: "Story templates"
  end

  test "should create story template" do
    visit story_templates_url
    click_on "New story template"

    fill_in "Description", with: @story_template.description
    fill_in "Internal notes", with: @story_template.internal_notes
    fill_in "Short code", with: @story_template.short_code
    fill_in "Template", with: @story_template.template
    fill_in "User", with: @story_template.user_id
    click_on "Create Story template"

    assert_text "Story template was successfully created"
    click_on "Back"
  end

  test "should update Story template" do
    visit story_template_url(@story_template)
    click_on "Edit this story template", match: :first

    fill_in "Description", with: @story_template.description
    fill_in "Internal notes", with: @story_template.internal_notes
    fill_in "Short code", with: @story_template.short_code
    fill_in "Template", with: @story_template.template
    fill_in "User", with: @story_template.user_id
    click_on "Update Story template"

    assert_text "Story template was successfully updated"
    click_on "Back"
  end

  test "should destroy Story template" do
    visit story_template_url(@story_template)
    click_on "Destroy this story template", match: :first

    assert_text "Story template was successfully destroyed"
  end
end
