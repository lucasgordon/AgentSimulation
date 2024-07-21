module ApplicationHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user_signin
    unless current_user
      redirect_to signin_url, alert: 'You must be signed in to access this page.'
    end
  end
end
