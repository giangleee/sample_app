module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: 80}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  # check user is admin and in local storage
  def is_admin? user
    current_user.admin? && !current_user?(user)
  end
end
