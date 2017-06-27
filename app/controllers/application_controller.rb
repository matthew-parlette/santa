class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include UserHelper

  private
    def configure_permitted_parameters
      update_attrs = [:password, :password_confirmation, :current_password, :avatar]
      devise_parameter_sanitizer.permit :account_update, keys: update_attrs
    end

    def visible_assignments
      if @user
        if @year
          if @year.to_i == Time.zone.now.year
            # Current year
            if @user == current_user
              @current_assignments = Assignment.where(user: @user, year: @year)
            else
              not_authorized
            end
          elsif @year.to_i < Time.zone.now.year
            # Previous year
            @previous_assignments = Assignment.where(user: @user, year: @year)
          else
            # Future year
            not_authorized
          end
        else
          # User's assignment index (no year specified)
          @previous_assignments = Assignment.where(["user_id = ? AND year < ?", @user.id, Time.zone.now.year])
          @current_assignments = Assignment.where(user: @user, year: Time.zone.now.year) if @user == current_user
        end
      else
        # Index (no user specified)
        if @year
          if @year.to_i == Time.zone.now.year
            # Current year
            @current_assignments = Assignment.where(user: current_user, year: @year)
          elsif @year.to_i < Time.zone.now.year
            # Previous year
            @previous_assignments = Assignment.where(year: @year)
          end
        else
          @previous_assignments = Assignment.where(["year < ?", Time.zone.now.year])
          @current_assignments = Assignment.where(user: current_user, year: Time.zone.now.year)
        end
      end
      @assignments = @previous_assignments
      @assignments += @current_assignments if @current_assignments
    end

    def visible_ideas
      if @id
        @idea = Idea.find(@id)
      else
        if @user
          # Ideas created by current user
          idea_ids = Idea.where(user: @user, created_by: current_user).pluck(:id)
          # Ideas created by others (public only)
          if current_user.id != @user.id
            idea_ids += Idea.where(user: @user, private: false).pluck(:id).uniq
          end
          # This step is required to only get unique entries
          @ideas = Idea.where(id: idea_ids)
          puts @ideas.inspect
        end
      end
    end

    def not_authorized
      raise ActionController::RoutingError.new('Not Authorized')
    end
end
