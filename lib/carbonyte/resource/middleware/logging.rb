# frozen_string_literal: true

require 'logger'
require 'carbonyte/support/logging/logstash_formatter'

module Carbonyte
  module Resource
    module Middleware
      # The Logging middleware logs requests and responses in logstash-style
      class Logging < Faraday::Middleware
        attr_reader :header_key, :logger, :log_level

        def initialize(app, logger = nil, log_level: :info)
          @logger = logger.dup || ::Logger.new($stdout)
          @logger.formatter = Carbonyte::Support::Logging::LogstashFormatter.new
          @log_level = validate_log_level(log_level)
          super(app)
        end

        def call(env)
          super
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

          logger.public_send(log_level, event)
        end

        def info_data(env)
          {
            correlation_id: correlation_id,
            method: env[:method],
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
            response_headers: env[:request_headers],
            response_body: env[:request_body]
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
