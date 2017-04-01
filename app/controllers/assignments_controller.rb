class AssignmentsController < InheritedResources::Base
  before_action :authenticate_user!

  # Show all assignments
  def index
    if params[:user_id].present? then
      # Get all assignments from previous years
      all_previous = Assignment.where(["user_id = ? AND year < ?", params[:user_id], Time.zone.now.year])

      if current_user.id.to_i == params[:user_id].to_i then
        current = Assignment.where(user: params[:user_id], year: Time.zone.now.year)
      end
    else
      # Get all assignments from previous years
      all_previous = Assignment.where(["year < ?", Time.zone.now.year])

      current = Assignment.where(user: current_user.id, year: Time.zone.now.year)
    end
    @assignments = all_previous
    @assignments += current unless current.nil?
  end

  # Show a specific year's assignments
  def show
    if params[:user_id].present? then
      not_authorized unless current_user.id.to_i == params[:user_id].to_i
      @assignments = Assignment.where(user: params[:user_id], year: params[:year])
    else
      if params[:year].to_i == Time.zone.now.year.to_i then
        @assignments = Assignment.where(user: current_user.id, year: params[:year])
      else
        @assignments = Assignment.where(year: params[:year])
      end
    end
  end

  private
    def not_authorized
      raise ActionController::RoutingError.new('Not Authorized')
    end
end
