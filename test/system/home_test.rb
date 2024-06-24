require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visiting root" do
    visit root_url
    assert_selector 'a', text: 'Sign in with Procore'
  end

  test "visiting home" do
    visit home_url
    assert_selector 'a', text: 'Sign in with Procore'
  end
end
