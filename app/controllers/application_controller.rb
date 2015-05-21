class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  prepend_before_filter :authenticate_user!

  after_action :set_access_control_headers

  helper_method :current_player

  def current_player
    @current_player ||= Player.by_email(current_user.email).try(:first) if current_user
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = %w{GET POST OPTIONS PUT}.join(",")
    headers['Access-Control-Allow-Headers'] = %w{Origin X-Requested-With Content-Type Accept}.join(",")
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS PUT}.join(",")
  end
end

