# frozen_string_literal: true

module MultiTenantSubdomain
  # This middleware is used to set the current tenant based on the subdomain
  # of the request.
  #
  # It is used to ensure that all requests are scoped to a single tenant.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      subdomain = extract_subdomain(env)
      tenant = MultiTenantSubdomain.config.tenant_model_table.classify.constantize.find_by(subdomain: subdomain)

      if tenant.nil? && subdomain.present?
        # Option 1: Return a 404 Not Found response
        return [404, {'Content-Type' => 'text/html'}, ['Tenant not found']]

        # Option 2: Redirect to main domain (uncomment to use)
        # main_domain = env['HTTP_HOST'].split('.').drop(1).join('.')
        # return [302, {'Location' => "https://#{main_domain}"}, []]
      end

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
      host_parts = request.host.split(".")

      # Avoid affecting primary domain
      return nil if host_parts.length < 3

      # Avoid affecting www subdomain
      return nil if host_parts.first == "www"

      host_parts.first
    end
  end
end
