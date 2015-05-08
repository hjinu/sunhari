class Api::V1::ConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token,
                   if: Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def index
	end

	private

	def sms_confirmation_params
		params.require(:sms_confirmation).permit(:phone)
	end
end
