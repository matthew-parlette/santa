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

  def friendly_name(user)
    if User.count(first_name: user.first_name) > 1
      user.first_name + user.last_name
    else
      user.first_name
    end
  end

  def color(user)
    color = ''.ljust(2, user.id.to_s)
    color += ''.ljust(2, Digest::MD5.hexdigest(user.first_name.to_s))
    color += ''.ljust(2, Digest::MD5.hexdigest(user.email.to_s))
    return color
  end

  def hidden_name(user)
    return Digest::MD5.hexdigest(user.id.to_s)
  end
end
