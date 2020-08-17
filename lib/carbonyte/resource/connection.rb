# frozen_string_literal: true

module Carbonyte
  module Resource
    # Custom Connection class to replace the standard one and inject middleware
    class Connection < JsonApiClient::Connection
      def initialize(options = {})
        super
        use(Middleware::Correlation)
      end
    end
  end
end
