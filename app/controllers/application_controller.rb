class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This is our new function that comes before Devise's one
  before_action :authenticate_user_from_token!
  # This is Devise's authentication
  before_action :authenticate_user!
  # This is for strong parameter
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:type, :phone, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:type, :login, :password, :remember_me) }
  end
 
  private
  
  def authenticate_user_from_token!
    authenticate_or_request_with_http_token do |token, options|
      user = User.find_by_authentication_token(token)

      if user
        sign_in user, store: false
      end
    end
  end
end
