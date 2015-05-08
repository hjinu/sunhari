class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token,
                     if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :authenticate_user_from_token!, only: [:create]

  respond_to :json

  def create
    warden.authenticate!(auth_options)
    render status: :ok,
           json: { :success => true,
                   :info => "Logged in",
                   :data => { :auth_token => current_user.authentication_token } }
  end

  def destroy
    warden.authenticate!(auth_options)
    current_user.update_column(:authentication_token, nil)
    sign_out(resource_name)
    render status: :ok,
           json: { :success => true,
                   :info => "Logged out",
                   :data => {} }
  end

  def failure
    render status: :unauthorized,
           json: { :success => false,
                   :info => "Login Failed" }
  end

  protected

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#failure" }
  end
end