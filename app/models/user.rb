class User < ActiveRecord::Base
	before_save :ensure_authentication_token

  devise :database_authenticatable, :registerable, :trackable, :validatable

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  # email이 아닌 attribute로 로그인하기 위한 override
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(phone) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
