class UserController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @user = current_user
    @user = User.find(params[:id]) if params[:id]
    visible_assignments
    visible_ideas
  end
end
