class ApplicationController < ActionController::API
  include Current
  include ApiRenderable
  include ApiPaginate

  before_action :authenticate_user!

  private

  def authenticate_user!
    render json: { error: 'Please login to continue' }, status: :unauthorized unless user_signed_in?
  end
end
