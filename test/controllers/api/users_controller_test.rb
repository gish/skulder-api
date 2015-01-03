require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should return all users when GET index" do
    expected = User.all.order(:uuid).as_json
    get :index
    users = JSON.parse(response.body)
    assert_equal expected, users
  end

  test "should create new user when POST valid user" do
    # given
    new_user = users(:complete)
    # when
    post :create, new_user.as_json
    # then
    created_user = User.where(:email => new_user.email).take
    assert_response :success
    assert_equal(new_user.email, created_user.email)
  end

  test "should return 400 when POST with last name missing" do
    # given
    new_user = users(:missing_last_name)
    expected_response = 400
    expected_type = "missing_parameter"
    # when
    post :create, new_user.as_json
    # then
    response_json = JSON.parse(response.body)
    assert_response expected_response
    assert_equal expected_type, response_json['type']
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get show" do
    get :show, {'id' => 1}
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

end
