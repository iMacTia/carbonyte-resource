# frozen_string_literal: true

require 'logger'
require 'carbonyte/support/logging/logstash_formatter'

module Carbonyte
  module Resource
    module Middleware
      # The Logging middleware logs requests and responses in logstash-style
      class Logging < Faraday::Middleware
        attr_reader :header_key, :logger, :log_level

        LOG_TYPE = 'RESOURCE_FETCH'

        def initialize(app, options = {})
          @logger = options[:logger].dup || ::Logger.new($stdout)
          @logger.formatter = Carbonyte::Support::Logging::LogstashFormatter.new
          @log_level = validate_log_level(options[:log_level] || :info)
          super(app)
        end

        def call(env)
          @app.call(env)
        rescue StandardError => e
          @raised_exception = e
        ensure
          log(env)
        end

        private

        def log(env)
          event = info_data(env)

          if log_level == :debug
            event.merge!(debug_request_data(env))
            event.merge!(debug_response_data(env))
          end

          event.merge!(exception_data(@raised_exception)) if @raised_exception

          logger.public_send(log_level, event)
        end

        def info_data(env)
          {
            type: LOG_TYPE,
            correlation_id: correlation_id,
            method: env[:method]&.upcase,
            url: env[:url],
            status: env[:status],
            reason_phrase: env[:reason_phrase]
          }
        end

        def debug_request_data(env)
          {
            request_headers: env[:request_headers],
            request_body: env[:request_body]
          }
        end

        def debug_response_data(env)
          {
            response_headers: env[:response_headers],
            response_body: env[:response_body]
          }
        end

        def exception_data(exc)
          {
            rescued_exception: {
              name: exc.class.name,
              message: exc.message,
              backtrace: %('#{Array(exc.backtrace.first(10)).join("\n\t")}')
            }
          }
        end

        def validate_log_level(log_level)
          return :info unless %i[debug info warn error fatal].include?(log_level)

          log_level
        end

        def correlation_id
          RequestStore.store[:correlation_id]
        end
      end
    end
  end
end
