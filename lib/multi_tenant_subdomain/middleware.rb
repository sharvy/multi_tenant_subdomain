module MultiTenantSubdomain
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      tenant = extract_subdomain(env)
      MultiTenantSubdomain::TenantManager.current_tenant = tenant
      @app.call(env)
    ensure
      # IMPORTANT: Reset the tenant after the request is processed
      # This ensures that the tenant is not shared between requests
      MultiTenantSubdomain::TenantManager.reset_tenant
    end

    private

    def extract_subdomain(env)
      request = Rack::Request.new(env)
      host_parts = request.host.split('.')
      
      # Avoid affecting primary domain
      return nil if host_parts.length < 3

      # Avoid affecting www subdomain
      return nil if host_parts.first == 'www'

      host_parts.first
    end
  end
end
