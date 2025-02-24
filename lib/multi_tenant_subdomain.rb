# frozen_string_literal: true

require_relative "multi_tenant_subdomain/version"
require_relative "multi_tenant_subdomain/railtie"
require_relative "multi_tenant_subdomain/tenant_manager"
require_relative "multi_tenant_subdomain/middleware"
require_relative "multi_tenant_subdomain/active_record_extension"
require_relative "generators/multi_tenant_subdomain/multi_tenant_subdomain_generator"

module MultiTenantSubdomain
  class Error < StandardError; end
  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield(config) if block_given?
    end
  end
  class Configuration
    attr_accessor :tenant_model

    def initialize
      @tenant_model = "Tenant"
    end
  end
end
