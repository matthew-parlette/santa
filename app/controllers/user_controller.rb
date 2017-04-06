class UserController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    visible_assignments
  end

  private
    def visible_assignments
      @assignments = Assignment.where(user_id: @user.id)
    end
end
