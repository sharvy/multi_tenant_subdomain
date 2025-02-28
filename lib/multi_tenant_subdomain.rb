# frozen_string_literal: true

require_relative "multi_tenant_subdomain/version"
require_relative "multi_tenant_subdomain/railtie"
require_relative "multi_tenant_subdomain/tenant_manager"
require_relative "multi_tenant_subdomain/middleware"
require_relative "multi_tenant_subdomain/active_record_extension"
require_relative "generators/multi_tenant_subdomain/multi_tenant_subdomain_generator"

##
# This module provides multi-tenant subdomain functionality for Rails applications.
#
# It allows you to easily scope your application's data and functionality
# to different tenants based on the subdomain in the request URL.
#
# To use this module, you need to:
#
#   1. Generate the necessary migrations and configurations using the provided generator:
#
#      `rails generate multi_tenant_subdomain YourTenantModelName`
#
#   2. Configure the module with your tenant model class and primary/foreign keys:
#
#      ```ruby
#      MultiTenantSubdomain.configure do |config|
#        config.tenant_model_class = "Account" # Default: "Tenant"
#        config.tenant_model_table = "accounts" # Default: "tenants"
#        config.tenant_model_pk = "id" # Default: "id"
#        config.tenant_model_fk = "account_id" # Default: "tenant_id"
#      end
#      ```
#
#   3. Use the `MultiTenantSubdomain::TenantManager.current_tenant` method to access the
#      current tenant in your controllers and views.
module MultiTenantSubdomain
  ##
  # Error class for any errors raised by the module.
  class Error < StandardError; end

  ##
  # Configuration class for the module.
  class Configuration
    ##
    # @!attribute tenant_model_class
    #   @return [String] The name of the tenant model class. Default: "Tenant".
    attr_accessor :tenant_model_class

    ##
    # @!attribute tenant_model_table
    #   @return [String] The name of the tenant model table. Default: "tenants".
    attr_accessor :tenant_model_table

    ##
    # @!attribute tenant_model_pk
    #   @return [String] The name of the primary key column on the tenant model. Default: "id".
    attr_accessor :tenant_model_pk

    ##
    # @!attribute tenant_model_fk
    #   @return [String] The name of the foreign key column on the models that should be scoped to a tenant. Default: "tenant_id".
    attr_accessor :tenant_model_fk

    # Initializes a new Configuration object with default values.
    def initialize
      @tenant_model_class = "Tenant"
      @tenant_model_table = "tenants"
      @tenant_model_pk = "id"
      @tenant_model_fk = "tenant_id"
    end
  end

  class << self
    ##
    # @!attribute config
    #   @return [Configuration] The configuration object for the module.
    attr_accessor :config

    ##
    # Configures the module.
    #
    # @yield [config] The configuration object.
    # @yieldparam config [Configuration] The configuration object.
    #
    # @example
    #   MultiTenantSubdomain.configure do |config|
    #     config.tenant_model_class = "Account"
    #     config.tenant_model_pk = "account_id"
    #     config.tenant_model_fk = "account_id"
    #   end
    def configure
      self.config ||= Configuration.new
      yield(config) if block_given?
    end
  end
end
