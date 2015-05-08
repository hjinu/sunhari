class SmsConfirmation < ActiveRecord::Base
	validates :phone, uniqueness: true

  def set_confirmation_key
    self.confirmation_key = generate_confirmation_key
  end

  def confirm(key)
  	self.confirmation_key == key
  end

  private

  def generate_confirmation_key
    token = Random.rand(1000..9999).to_s
  end

end
