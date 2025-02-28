# frozen_string_literal: true

MultiTenantSubdomain.configure do |config|
  config.tenant_model_class = "<%= model_name.to_s.camelize %>"
  config.tenant_model_table = "<%= model_name.tableize %>"
  config.tenant_model_pk = "id"
  config.tenant_model_fk = "<%= model_name.underscore %>_id"
end
