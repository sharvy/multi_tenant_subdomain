require "rails_helper"
require "generator_spec"
require "generators/multi_tenant_subdomain/multi_tenant_subdomain_generator"

RSpec.describe MultiTenantSubdomain::MultiTenantSubdomainGenerator, type: :generator do
  destination File.expand_path("../../tmp", __dir__) # Temp folder for test files

  before(:all) do
    prepare_destination
    run_generator ["Garage"]
  end

  it "creates the model file" do
    expect(file("app/models/garage.rb")).to exist
  end

  it "creates the initializer" do
    expect(file("config/initializers/multi_tenant_subdomain.rb")).to exist
  end
end
