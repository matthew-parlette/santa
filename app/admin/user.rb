include Devise

ActiveAdmin.register User do

  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :avatar,
                assignment_bans_attributes: [:id, :user, :assigned_to_id, :_destroy],
                ideas_attributes: [:id, :name, :user, :created_by_id, :_destroy]

  controller do
    def create
      if params[:user][:password].blank?
        password = Devise.friendly_token.first(8)
        %w(password password_confirmation).each { |p| params[p] = password }
      end
      super
    end
    def update
      if params[:user][:password].blank?
        %w(password password_confirmation).each { |p| params[:user].delete(p) }
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :first_name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    panel "Details" do
      table_for user do
        column :avatar do
          user.avatar? ? image_tag(user.avatar.url, height: '50') : content_tag(:span, "No avatar")
        end
        column :first_name
        column :email
        column :current_sign_in_at
        column :sign_in_count
      end
    end
    panel "Bans" do
      table_for user.assignment_bans do
        column :assigned_to
      end
    end
  end

  filter :first_name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password, :required => false, :hint => "Leave blank to auto-generate"
      f.input :password_confirmation, :required => false
      f.input :avatar, as: :file
    end
    f.has_many :assignment_bans do |ban|
      ban.inputs "Bans" do
        if !ban.object.nil?
          ban.input :_destroy, :as => :boolean, :label => "Delete?"
        end

        ban.input :user, collection: User.all.collect {|u| [u.email, u.id]}, as: :select
        ban.input :assigned_to, collection: User.all.collect {|u| [u.email, u.id]}, as: :select
      end
    end
    f.actions
  end

  # Reminder email
  action_item :email, only: :show do
    link_to "Send Reminder Email", email_admin_user_path, :method => :post
  end

  member_action :email, :method => :post do
    AssignmentMailer.assignment_reminder(User.find(params[:id]))
    redirect_to admin_user_path, :notice => "Reminder sent!"
  end

end
