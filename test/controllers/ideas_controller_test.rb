require 'test_helper'

class IdeasControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @idea = ideas(:one)
    @user = users(:one)
    sign_in @user
    @user_id = User.where(email: @user.email).first.id
  end

  # Response
  test "should get index for a user" do
    get user_ideas_url(@user)
    assert_response :success
  end

  test "should get new" do
    get new_user_idea_url(@user)
    assert_response :success
  end

  test "should create idea" do
    assert_difference('Idea.count') do
      post user_ideas_url(@user), params: { idea: { created_by_id: @idea.created_by_id, name: @idea.name, private: @idea.private } }
    end

    assert_redirected_to user_idea_url(@user, Idea.last)
  end

  test "should create a private idea" do
    @idea = ideas(:four)
    assert_difference('Idea.count') do
      post user_ideas_url(@user), params: { idea: { created_by_id: @idea.created_by_id, name: @idea.name, private: @idea.private } }
    end

    assert_redirected_to user_idea_url(@user, Idea.last)
  end

  test "should show idea" do
    get user_ideas_url(@user, @idea)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_idea_url(@user, @idea)
    assert_response :success
  end

  test "should update idea" do
    patch user_idea_url(@user, @idea), params: { idea: { created_by_id: @idea.created_by_id, name: @idea.name, private: @idea.private } }
    assert_redirected_to user_idea_url(@user, @idea)
  end

  test "should destroy idea" do
    assert_difference('Idea.count', -1) do
      delete user_idea_url(@user, @idea)
    end

    assert_redirected_to user_ideas_url(@user)
  end

  # Content
  test "user can see ideas they created for themselves" do
    get user_ideas_url(@user), params: { format: :json }
    ideas_created_for_user_by_user = 0
    JSON.parse(@response.body).each do |obj|
      ideas_created_for_user_by_user += 1 if obj["created_by_id"] == @user_id
    end
    assert_equal 1, ideas_created_for_user_by_user
  end

  test "user cannot see ideas created by others for them" do
    get user_ideas_url(@user), params: { format: :json }
    ideas_created_for_user_by_other_users = 0
    JSON.parse(@response.body).each do |obj|
      ideas_created_for_user_by_other_users += 1 if obj["created_by_id"] != @user_id
    end
    assert_equal 0, ideas_created_for_user_by_other_users
  end

  test "user can see ideas for others" do
    get user_ideas_url(users(:two)), params: { format: :json }
    assert_equal 2, JSON.parse(@response.body).count
  end

  test "user cannot see other user's private idea" do
    get user_ideas_url(users(:two)), params: { format: :json }
    JSON.parse(@response.body).each do |obj|
      assert_not_equal "idea six", obj["name"]
    end
  end
end
