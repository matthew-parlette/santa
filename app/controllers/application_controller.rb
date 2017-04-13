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

    def visible_ideas
      if @id
        @idea = Idea.find(@id)
      else
        if @user
          # Ideas created by current user
          idea_ids = Idea.where(user: @user.id, created_by: current_user).pluck(:id)
          # Ideas created by others (public only)
          if current_user.id != @user.id
            idea_ids += Idea.where(user: @user, private: false).pluck(:id).uniq
          end
          # This step is required to only get unique entries
          @ideas = Idea.where(id: idea_ids)
        end
      end
    end

    def not_authorized
      raise ActionController::RoutingError.new('Not Authorized')
    end
end
