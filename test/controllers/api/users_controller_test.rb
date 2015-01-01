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
    given_name = 'Jane'
    last_name = 'Doe'
    email = 'jane@doe.com'

    new_user = User.new(
      :given_name => given_name,
      :last_name => last_name,
      :email => email
    ).as_json

    # when
    post :create, user: new_user

    # then
    returned_user = JSON.parse(response.body)
    assert_response :success
    assert_user_as_json new_user, returned_user
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
