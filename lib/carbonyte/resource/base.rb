# frozen_string_literal: true

module Carbonyte
  module Resource
    # Base class for all resources
    class Base < JsonApiClient::Resource
      self.connection_class = Carbonyte::Resource::Connection
    end
  end
end
