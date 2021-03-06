require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should not get index" do
    get :index, format: :json
    assert_response :unauthorized
  end

  test "should get index succress responce and correct json response" do
    set_headers(@user)
    get :index, format: :json
    assert_response :success

    users = User.where(activated: true).paginate(page: 1)

    pattern = {
      users: users.map {|user| {
        id: user[:id], name: user[:name], email: user[:email]
      }}.ordered!
    }
    assert_json_match pattern, response.body
  end

  test "should get show success responce and correct json response" do
    set_headers(@user)
    get :show, params: { id: @user }, format: :json
    assert_response :success

    feeds = @user.microposts.paginate(page: 1)

    pattern = {
      feeds: feeds.map {|feed| {
        user_id: @user.id, name: @user.name,
        id: feed[:id], content: feed[:content], created_at: feed[:created_at]
      }}.ordered!
    }
    assert_json_match pattern, response.body
  end

  test "invalid signup information" do
    assert_no_difference "User.count" do
      post :create, format: :json, params: {
        user: { name: "",email: "user@invalid", password: "foo", password_confirmation: "bar" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "valid signup information" do
    assert_difference "User.count", 1 do
      post :create, format: :json, params: { user:
        { name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password" }
      }
    end
    assert_response :created
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "invalid user update" do
    set_headers(@user)
    patch :update, format: :json, params: { id: @user,  user:
      { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" }
    }
    assert_response :unprocessable_entity
  end

  test "valid user update" do
    set_headers(@user)
    name = "Foo Bar"
    email = "foo@bar.com"

    patch :update, format: :json, params: { id: @user, user:
      { name: name, email: email, password: "", password_confirmation: "" }
    }
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert_response :ok
  end

  test "should fail destroy when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, params: { id: @user }, format: :json
    end
    assert_response :unauthorized
  end

  test "should fail destroy when logged in as a non-admin" do
    set_headers(@other_user)
    assert_no_difference "User.count" do
      delete :destroy, params: { id: @other_user }, format: :json
    end
    assert_response :bad_request
  end

  test "should success destroy" do
    set_headers(@user)
    assert_difference "User.count", -1 do
      delete :destroy, params: { id: @user }, format: :json
    end
    assert_response :ok
  end

  test "should not get following success responce" do
    get :following, params: { id: @user }, format: :json
    assert_response :unauthorized
  end

  test "should get following success responce" do
    set_headers(@user)
    get :following, params: { id: @user }, format: :json
    assert_response :ok

    followings = @user.following.paginate(page: 1)

    pattern = {
      user: {
        id: @user.id, name: @user.name
      }.ignore_extra_keys!,
      following: followings.map {|following| {
        id: following[:id], name: following[:name], img: gravatar_url(following, size: 50)
      }}.ordered!
    }
    assert_json_match pattern, response.body
  end

  test "should not get followers success responce" do
    get :followers, params: { id: @user }, format: :json
    assert_response :unauthorized
  end

  test "should get followers success responce" do
    set_headers(@user)
    get :followers, params: { id: @user }, format: :son
    assert_response :ok

    followers = @user.followers.paginate(page: 1)

    pattern = {
      user: {
        id: @user.id, name: @user.name
      }.ignore_extra_keys!,
      followers: followers.map {|follower| {
        id: follower[:id], name: follower[:name], img: gravatar_url(follower, size: 50)
      }}.ordered!
    }
    assert_json_match pattern, response.body
  end
end
