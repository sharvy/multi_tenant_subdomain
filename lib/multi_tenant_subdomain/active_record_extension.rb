module MultiTenantSubdomain
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      default_scope { where(tenant_id: MultiTenantSubdomain::TenantManager.current_tenant&.id) }
      before_validation :set_tenant_id
    end

    private

    def set_tenant_id
      self.tenant_id = MultiTenantSubdomain::TenantManager.current_tenant&.id
    end
  end
end

ActiveRecord::Base.include MultiTenantSubdomain::ActiveRecordExtension
