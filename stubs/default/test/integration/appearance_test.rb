require 'test_helper'

class AppearanceTest < ActionDispatch::IntegrationTest
  test 'appearance page is displayed' do
    user = FactoryBot.create(:user)

    acting_as(user).get appearance_edit_path

    assert_response :success
  end
end
