# frozen_string_literal: true

module MultiTenantSubdomain
  # This module is used to extend ActiveRecord models to support multi-tenant
  # subdomains.
  #
  # It adds a default scope to the model to ensure that all records are
  # scoped to the current tenant.
  #
  # It also adds a before_validation callback to set the tenant_id on the
  # model.
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      # Don't try to access the database during class loading
      # Instead, set up a hook that will be called when the model is used
      after_initialize :ensure_tenant_configured, if: :tenant_configured?

      # Class method to temporarily disable tenant scoping
      define_singleton_method(
        "without_#{MultiTenantSubdomain.config.tenant_model_class.to_s.underscore}_scope".to_sym
      ) do |&block|
        unscoped(&block)
      end
    end

    class_methods do
      def tenant_configured?
        # Safely check if we can access table information without raising errors
        begin
          connected? && table_exists? &&
            column_names.include?(MultiTenantSubdomain.config.tenant_model_fk)
        rescue => e
          false
        end
      end

      # Apply tenant scoping when the model is used
      def apply_tenant_scoping
        # Only apply if not already applied
        return if instance_variable_defined?(:@tenant_scoping_applied)

        before_validation :set_tenant_id
        default_scope do
            where(
              MultiTenantSubdomain.config.tenant_model_fk =>
                MultiTenantSubdomain::TenantManager.current_tenant.send(
                  MultiTenantSubdomain.config.tenant_model_pk.to_sym
                )
            )
        end
        @tenant_scoping_applied = true
      end
    end

    private

    def tenant_configured?
      self.class.tenant_configured?
    end

    def ensure_tenant_configured
      self.class.apply_tenant_scoping
    end

    def set_tenant_id
      self[MultiTenantSubdomain.config.tenant_model_fk.to_sym] = MultiTenantSubdomain::TenantManager.current_tenant.send(
        MultiTenantSubdomain.config.tenant_model_pk.to_sym
      )
    end
  end
end

# Use ActiveSupport.on_load to include the module in ActiveRecord::Base
# This ensures that the module is loaded at the right time in the Rails initialization process
ActiveSupport.on_load(:active_record) do
  include MultiTenantSubdomain::ActiveRecordExtension
end
