# frozen_string_literal: true

module Carbonyte
  module Resource
    # Custom Connection class to replace the standard one and inject middleware
    # @param options [Hash]
    #   @option :correlation_header [String] the header key for the correlation ID
    #   @option :logger_options [Hash]
    #     @option :logger [Logger] the logger to use. Defaults to a new Logger
    #     @option :log_level [Symbol] the logger level to use. Defaults to :info
    class Connection < JsonApiClient::Connection
      def initialize(options = {})
        super
        logger_options = options[:logger_options]
        use(Middleware::Correlation, options[:correlation_header])
        use(Middleware::Logging, logger_options)
      end
    end
  end
end
