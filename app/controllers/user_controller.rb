class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :additional_options

  def index
    @users = User.all
  end

  def show
    @user = current_user
    @user = User.find(params[:id]) if params[:id]
    visible_assignments
    visible_ideas
  end

  private
    def additional_options
      @additional_options = 'user/menu'
    end
end
