module MultiTenantSubdomain
  class Railtie < Rails::Railtie
    initializer "multi_tenant_subdomain.configure_rails_initialization" do |app|
      app.middleware.use MultiTenantSubdomain::Middleware
    end
  end
end
