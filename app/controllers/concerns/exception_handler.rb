module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordNotFound, with: :request_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_request
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_request
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_request
  end

  private

    # JSON response with message; Status code 422 - Unprocessable entity
    def unprocessable_request(e)
      json_response({ message: e.message }, :unprocessable_entity)
    end

    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(e)
      json_response({ message: e.message }, :unauthorized)
    end

    # JSON response with message; Status code 400 - Not found
    def request_not_found(e)
      json_response({ message: e.message }, :not_found)
    end
end
