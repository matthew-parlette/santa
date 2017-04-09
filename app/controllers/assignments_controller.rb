class AssignmentsController < InheritedResources::Base
  before_action :authenticate_user!

  # Show all assignments
  def index
    @user = User.find(params[:user_id]) if params[:user_id].present?
    visible_assignments
  end

  # Show a specific year's assignments
  def show
    @year = params[:year]
    @user = User.find(params[:user_id]) if params[:user_id].present?
    visible_assignments
  end
end
