module MultiTenantSubdomain
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
