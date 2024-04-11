module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = User.find(user_id)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def secret_key_base
      Rails.application.credentials.secret_key_base
    end

    def decoded_token
      JWT.decode(request.params['token'], secret_key_base)
    rescue StandardError
      Rails.logger.error('Invalid Token')
    end

    def user_id
      decoded_token.first['user_id']
    end
  end
end
