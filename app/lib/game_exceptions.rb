module GameExceptions 
    class MaximumAttempts < StandardError
      def message
        'The maximum number of attempts was reached'
      end
    end
  end