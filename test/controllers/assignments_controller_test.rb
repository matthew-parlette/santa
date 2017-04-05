require 'test_helper'

class AssignmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @this_year = 2017
    sign_in users(:one)
    @user_id = User.where(email: users(:one).email).first.id
  end

  # Response
  test "should get index" do
    get assignments_url
    assert_response :success
  end

  test "should show assignment" do
    get assignment_url(@this_year)
    assert_response :success
  end

  test "user can see their assignment for the current year" do
    get user_assignment_url(users(:one), @this_year)
    assert_response :success
  end

  test "user cannot see another user's assignment for the current year" do
    assert_raises(ActionController::RoutingError) do
      get user_assignment_url(users(:two), @this_year)
    end
  end

  # Content
  test "user can see all assignments from previous year" do
    get assignments_url, params: { format: :json }
    assignments_from_last_year = 0
    JSON.parse(@response.body).each do |obj|
      assignments_from_last_year += 1 unless obj["year"] == @this_year
    end
    assert_equal assignments_from_last_year, 2
  end

  test "user cannot see any assignment for next year" do
    get assignments_url, params: { format: :json }
    assignments_from_next_year = 0
    JSON.parse(@response.body).each do |obj|
      assignments_from_next_year += 1 unless obj["year"] <= @this_year
    end
    assert_equal assignments_from_next_year, 0
  end

  test "index should show all of previous year plus user's assignment this year" do
    get assignments_url, params: { format: :json }
    assert_equal JSON.parse(@response.body).count, 3
  end

  test "index with user should only show user's assignments" do
    get user_assignment_index_url(@user_id), params: { format: :json }
    JSON.parse(@response.body).each do |obj|
      assert_equal obj["user_id"], @user_id
    end
  end

  test "show year should show all assignments of previous year" do
    last_year = @this_year - 1
    get assignment_url(@this_year - 1), params: { format: :json }
    assert_equal JSON.parse(@response.body).count, 2
    JSON.parse(@response.body).each do |obj|
      assert_equal obj["year"], (@this_year - 1)
    end
  end

  test "show year should show only current user's assignment for current year" do
    get assignment_url(@this_year), params: { format: :json }
    assert_equal JSON.parse(@response.body).count, 1
    JSON.parse(@response.body).each do |obj|
      assert_equal obj["year"], (@this_year)
      assert_equal obj["user_id"], @user_id
    end
  end

  test "index for other user should not show current year assignment" do
    user_two_id = User.where(email: users(:two).email).first.id
    get user_assignment_index_url(user_two_id), params: { format: :json }
    JSON.parse(@response.body).each do |obj|
      assert_not_equal obj["year"], @current_year
    end
  end
end
