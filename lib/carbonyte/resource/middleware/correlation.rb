# frozen_string_literal: true

module Carbonyte
  module Resource
    module Middleware
      # The Correlation middleware takes the correlation ID from the RequestStore and
      class Correlation < Faraday::Middleware
        attr_reader :header_key

        def initialize(app, key = nil)
          @header_key = key || 'X-Correlation-Id'
          super(app)
        end

        def call(env)
          env.request_headers[header_key] = RequestStore.store[:correlation_id]
          @app.call(env)
        end
      end
    end
  end
end
