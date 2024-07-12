require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @access_token = "access_token"
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "should update Project" do
    visit project_url(@project)
    click_on "Edit this project", match: :first

    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end
end
