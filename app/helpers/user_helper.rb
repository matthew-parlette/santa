module UserHelper
  def name(user)
    if User.count(first_name: user.first_name) > 1
      user.first_name + user.last_name
    else
      user.first_name
    end
  end
end
