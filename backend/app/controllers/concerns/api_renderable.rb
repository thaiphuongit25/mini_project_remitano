# frozen_string_literal: true

module ApiRenderable
  extend ActiveSupport::Concern

  class Forbidden < ActionController::ActionControllerError; end
  included do
    respond_to :json

    before_action :force_json_format

    rescue_from ActiveRecord::RecordNotFound do |_exception|
      render error: :record_not_found, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render error: :record_invalid, model: exception.record, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |exception|
      render error: :destroy_invalid, model: exception.record, status: :unprocessable_entity
    end

    rescue_from Forbidden, with: :rescue_error403
  end

  ActionController::Renderers.add :error do |obj, options|
    render_error_response obj, options
  end

  protected

  def common_errors
    %i[
      record_invalid
      update_invalid
      user_not_found
      invalid_token
      email_invalid
      forbidden_error
    ]
  end

  ActionController::Renderers.add :error do |obj, options|
    render_error_response obj, error_model: options[:model],
                               http_status_code: options[:status],
                               message_variables: options[:message_variables] || {}
  end

  def force_json_format
    request.format = :json
  end

  def render_error_response(error_key, error_model: nil, http_status_code: 400, message_variables: {})
    i18n_key = "api.errors.#{error_key}"

    i18n_variables = message_variables
    i18n_variables[:model] = error_model.model_name.human.presence || error_model.model_name if error_model

    error_json = {
      errorCode: I18n.t("#{i18n_key}.code"),
      message: I18n.t("#{i18n_key}.message", **i18n_variables),
      detail: error_detail(error_model)
    }.as_json

    render json: error_json, status: http_status_code
  end

  def error_detail(error_model)
    if !error_model || error_model.errors.blank?
      {}
    else
      error_model.errors.attribute_names.to_h do |k|
        [k.to_s.camelize(:lower).to_sym, error_model.errors.full_messages_for(k)]
      end
    end
  end

  def rescue_error403(err)
    _render_error(err:, status: 403)
  end

  def _render_error(err:, status: 500)
    logger.info "Rendering #{status} with exception: #{err.message}" if err

    render(json: { error: "#{status} error", message: err }, status:)
  end
end
