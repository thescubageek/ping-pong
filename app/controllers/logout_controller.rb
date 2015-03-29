class LogoutController < ApplicationController
  def index
    auth_user = G5Authenticatable::User.where('email = ?', current_user.email) if current_user
    auth_user.destroy_all if auth_user
    redirect_to "ENV['G5_AUTH_ENDPOINT']}/users/sign_out"
  end
end