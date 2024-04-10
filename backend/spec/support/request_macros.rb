# frozen_string_literal: true

module RequestMacros
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
end
