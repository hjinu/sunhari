class Api::V1::SmsConfirmationsController < ApplicationController
  skip_before_action :verify_authenticity_token,
                   if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :authenticate_user_from_token!, :authenticate_user!

	respond_to :json

	def create
		@sms_confirmation = SmsConfirmation.find_or_initialize_by(sms_confirmation_params)
		@sms_confirmation.set_confirmation_key

		if @sms_confirmation.save
			render json: @sms_confirmation
		end
	end

	def destroy
		@sms_confirmation = SmsConfirmation.find(params[:id])
		@sms_confirmation.destroy
	end

	private

	def sms_confirmation_params
		params.require(:sms_confirmation).permit(:phone)
	end
end
