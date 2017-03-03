class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :authenticate_admin!, only: [:admin]

  def index
    # render 'index'
  end

  def admin
    @users = User.all
  end

  private
    def authenticate_admin!
      redirect_to root_path unless current_user.admin?
    end
end
