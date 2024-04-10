# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!

      def create
        user = User.find_by(email: user_params[:email])

        if user&.valid_password?(user_params[:password])
          token = generate_jwt(user)
          render json: { token: }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def register
        @user = User.new(user_params)
        @user.save!
        token = generate_jwt(@user)
        render json: { token: }, status: :created
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
