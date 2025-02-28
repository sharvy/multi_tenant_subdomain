# frozen_string_literal: true

module MultiTenantSubdomain
  # This class is used to manage the current tenant.
  #
  # It is used to ensure that all requests are scoped to a single tenant.
  class TenantManager
    MTS_KEY = :current_tenant

    class << self
      def current_tenant
        Thread.current[MTS_KEY]
      end

      def current_tenant=(tenant)
        Thread.current[MTS_KEY] = tenant
      end

      def reset_tenant
        Thread.current[MTS_KEY] = nil
      end
    end
  end
end
