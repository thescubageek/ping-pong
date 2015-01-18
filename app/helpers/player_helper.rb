module PlayerHelper
  def avatar_url(player)
    default_url = asset_url "guest.png"
    gravatar_id = Digest::MD5.hexdigest(player.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end
end
