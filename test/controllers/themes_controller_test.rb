require 'test_helper'

class ThemesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get root as new" do
    assert_routing "/", :controller => "themes", :action => "new"
  end

  test "should get create as theme compressed file" do
    get :create, { name: "Create Theme", slug: "createtheme" }
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end

end
