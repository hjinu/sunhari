class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token,
                     if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :authenticate_user_from_token!

  respond_to :json

  def create
    sms_confirmation = SmsConfirmation.find_by(phone: registration_params[:phone])

    if sms_confirmation && sms_confirmation.confirm(confirmation_params[:sms_confirmation_key])
      build_resource(registration_params)

      if resource.save
        sms_confirmation.destroy
        render json: resource
      else
        render_error(resource.errors.full_messages.first)
      end
    else
      render_error("invalid confirmation key")
    end
  end

  def render_error(msg)
    render json: {
      error: msg
    }, status: 400
  end

  private

  def registration_params
    params.require(:user).permit(:phone, :password)
  end

  def confirmation_params
    params.require(:user).permit(:sms_confirmation_key)
  end
end