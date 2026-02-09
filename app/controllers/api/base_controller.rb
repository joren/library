module Api
  class BaseController < ActionController::API
    before_action :authenticate_api_key

    private

    def authenticate_api_key
      api_key = request.headers["Authorization"]&.remove("Bearer ")
      expected_key = ENV["LIBRARY_API_KEY"] || Rails.application.credentials.dig(:api_key)

      if expected_key.blank?
        render json: { error: "API key not configured" }, status: :internal_server_error
      elsif api_key.blank? || !ActiveSupport::SecurityUtils.secure_compare(api_key, expected_key)
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
