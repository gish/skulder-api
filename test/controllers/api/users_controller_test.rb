require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def assert_user_as_json(expected, actual)
    expected['created_at'] = nil
    expected['updated_at'] = nil
    actual['created_at'] = nil
    actual['updated_at'] = nil
    actual['uuid'] = expected['uuid']
    assert_equal expected, actual
  end

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
    new_user = users(:complete).as_json

    # when
    post :create, new_user

    # then
    returned_user = JSON.parse(response.body)
    assert_response :success
    assert_user_as_json new_user, returned_user
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
