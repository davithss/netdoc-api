class ApplicationController < ActionController::API
    #rescue_from GameExceptions::MaximumAttempts, with: :api_error
    #rescue_from ActiveRecord::ActiveRecordError, with: :not_found
  
    def health_check
      render json: { 'message': "I'm working fine!" }, status: :ok
    end
  
    def api_error(exception, status = :unprocessable_entity)
      render json: { 'error': exception.class, 'message': exception.message }, status: status
    end
  
    def not_found(exception)
      api_error(exception, :not_found)
    end
end
