class Api::V1::ConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token,
                   if: Proc.new { |c| c.request.format == 'application/json' }

	respond_to :json

	def index
		@senders = current_user.senders
		@ids = []
		@senders.count.times do |i|
			@ids << "id#{i}"
		end

		puts "idiidididididi"
		puts @ids

		respond_with @senders
	end

	private

	def conversation_params
		params.require(:conversation).permit(:phone)
	end
end
