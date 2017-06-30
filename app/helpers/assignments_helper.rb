module AssignmentsHelper
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
