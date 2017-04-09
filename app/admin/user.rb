ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :first_name, :last_name, :email, :password, :password_confirmation,
                assignment_bans_attributes: [:id, :user, :assigned_to_id, :_destroy]

  controller do
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
      f.input :password
      f.input :password_confirmation
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

end
