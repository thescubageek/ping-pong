class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  after_action :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = %w{GET POST OPTIONS PUT}.join(",")
    headers['Access-Control-Allow-Headers'] = %w{Origin X-Requested-With Content-Type Accept}.join(",")
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS PUT}.join(",")
  end
end

