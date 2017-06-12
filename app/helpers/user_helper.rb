module UserHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def name(user)
    if User.count(first_name: user.first_name) > 1
      user.first_name + user.last_name
    else
      user.first_name
    end
  end
end
