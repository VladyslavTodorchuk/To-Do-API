class User < ApplicationRecord
  MAX_USERNAME_LENGTH = 50
  MIN_USERNAME_LENGTH = 3

  MIN_PASSWORD_LENGTH = 8
  PASSWORD_FORMAT = /[a-zA-Z]*/.freeze

  has_many :projects, dependent: :destroy

  validates :username, allow_blank: false, length: { minimum: MIN_USERNAME_LENGTH, maximum: MAX_USERNAME_LENGTH }
  validates :password, allow_blank: false, length: { minimum: MIN_PASSWORD_LENGTH },
                       format: { with: PASSWORD_FORMAT,
                                 message: I18n.t('user.password_validates') }

  def valid_password?(param_password)
    password.match(param_password)
  end
end
