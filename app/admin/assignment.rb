include AssignmentsHelper

ActiveAdmin.register Assignment do

  before_filter :only => [:index] do
    if params['commit'].blank? && params['q'].blank? && params[:scope].blank?
       params['q'] = {:year_eq => Time.zone.now.year}
    end
  end

  permit_params :user, :assigned_to, :year

  index do
    selectable_column
    id_column
    column :user do |assignment|
      "<div style=\"background-color: ##{color(assignment.user)};text-align: center\">#{hidden_name(assignment.user)}</div>".html_safe
    end
    column :assigned_to do |assignment|
      "<div style=\"background-color: ##{color(assignment.assigned_to)};text-align: center\">#{hidden_name(assignment.assigned_to)}</div>".html_safe
    end
    column :year
    actions
  end

  show do
    panel "Assignment" do
      table_for assignment do
        column :user
        column :assigned_to
        column :year
      end
    end
  end

  filter :user
  filter :assigned_to
  filter :year

  form do |f|
    f.inputs "Assignment" do
      f.input :user
      f.input :assigned_to
      f.input :year
    end
    f.actions
  end

end
