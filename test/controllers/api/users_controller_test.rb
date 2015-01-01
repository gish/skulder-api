require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should return all users when GET index" do
    expected = User.all.order(:uuid).as_json(
      :only => [:uuid, :given_name, :last_name, :email, :created_at, :updated_at]
    )
    get :index
    users = JSON.parse(response.body)
    assert_equal expected, users
  end

  test "should get create" do
    get :create
    assert_response :success
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
