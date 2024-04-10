# frozen_string_literal: true

module Current
  thread_mattr_accessor :user

  extend ActiveSupport::Concern

  included do
    around_action :set_current_user
  end

  protected

  def secret_key_base
    Rails.application.credentials.secret_key_base
  end

  def generate_jwt(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 4.hours.from_now.to_i
    }
    JWT.encode(payload, secret_key_base)
  end

  def decoded_token
    JWT.decode(token, secret_key_base)
  rescue StandardError
    Rails.logger.error('Invalid Token')

    [{ error: 'Invalid Token' }]
  end

  def token
    request.headers['Authorization'].scan(/Bearer (.*)$/).flatten.last.to_s
  end

  def user_id
    decoded_token.first['user_id']
  end

  def current_user
    @current_user ||= User.find_by(id: user_id)
  end

  def user_signed_in?
    current_user.present?
  end

  private

  def set_current_user
    Current.user = current_user if user_signed_in?
    yield
  ensure
    Current.user = nil
  end
end
