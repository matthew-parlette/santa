class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :additional_options
  before_action :find_user

  def index
    @users = User.all
  end

  def show
    visible_assignments
    visible_ideas
  end

  def ideas
    visible_ideas
    render 'show'
  end

  def edit
    @user = current_user
    render 'devise/registrations/edit'
  end

  def update
    puts @user.first_name
    puts @user.update_attributes(user_params)
    render 'show'
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation, :avatar)
    end

    def additional_options
      @additional_options = 'user/menu'
    end

    def find_user
      @user = current_user
      @user = User.find(params[:id]) if params[:id]
    end
end
