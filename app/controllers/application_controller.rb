class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UserHelper

  private
    def visible_assignments
      if @user
        if @year
          if @year.to_i == Time.zone.now.year
            # Current year
            if @user == current_user
              @assignments = Assignment.where(user: @user, year: @year)
            else
              not_authorized
            end
          elsif @year.to_i < Time.zone.now.year
            # Previous year
            @assignments = Assignment.where(user: @user, year: @year)
          else
            # Future year
            not_authorized
          end
        else
          # User's assignment index (no year specified)
          @assignments = Assignment.where(["user_id = ? AND year < ?", @user.id, Time.zone.now.year])
          @assignments += Assignment.where(user: @user, year: Time.zone.now.year) if @user == current_user
        end
      else
        # Index (no user specified)
        if @year
          if @year.to_i == Time.zone.now.year
            # Current year
            @assignments = Assignment.where(user: current_user, year: @year)
          elsif @year.to_i < Time.zone.now.year
            # Previous year
            @assignments = Assignment.where(year: @year)
          end
        else
          @assignments = Assignment.where(["year < ?", Time.zone.now.year])
          @assignments += Assignment.where(user: current_user, year: Time.zone.now.year)
        end
      end
    end

    def not_authorized
      raise ActionController::RoutingError.new('Not Authorized')
    end
end
