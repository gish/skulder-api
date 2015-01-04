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
    new_user = User.new(
      :email => 'new@foo.com',
      :given_name => 'New',
      :last_name => 'Foo'
    )
    # when
    post :create, new_user.as_json
    # then
    location = response.location
    assert_response :success
    assert(User.exists?(:email => new_user.email))
    assert_equal(api_user_url(User.where(:email => new_user.email).take.uuid), location)
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

  test "should not create user when user with email exists" do
    # given
    new_user = users(:complete)
    expected_response = 406
    expected_type = 'email_exists'
    # when
    post :create, new_user.as_json
    # then
    response_json = JSON.parse(response.body)
    assert_response expected_response
    assert_equal expected_type, response_json['type']
  end

  test "should delete destroy" do
    delete :destroy, {'id' => 1}
    assert_response :success
  end

  test "should get show" do
    get :show, {'id' => 1}
    assert_response :success
  end

  test "should GET user when show" do
    # given
    expected_user = users(:complete)
    # when
    get :show, {'id' => users(:complete).uuid}
    # then
    returned_user = JSON.parse(response.body)
    assert_equal(expected_user.uuid, returned_user['uuid'])
    assert_equal(expected_user.given_name, returned_user['given_name'])
    assert_equal(expected_user.last_name, returned_user['last_name'])
    assert_equal(expected_user.email, returned_user['email'])
  end

  test "should patch update" do
    patch :update, {'id' => 1}
    assert_response :success
  end

end
