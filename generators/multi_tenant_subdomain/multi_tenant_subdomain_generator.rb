require "rails/generators"
require "active_record"
require "fileutils"

module MultiTenantSubdomain
  class MultiTenantSubdomainGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)
    argument :model_name, type: :string

    def create_model
      return if behavior != :invoke

      if model_exists?
        add_subdomain_field if migration_needed?
      else
        generate "model", "#{model_name} subdomain:string:index"
      end

      create_initializer
    end

    def destroy
      return if behavior != :revoke

      remove_initializer
      remove_model if model_exists?
      remove_migrations
    end

    private

    def model_exists?
      File.exist?(Rails.root.join("app", "models", "#{model_name.underscore}.rb"))
    end

    def table_exists?
      ActiveRecord::Base.connection.data_source_exists?(model_name.tableize)
    end

    def column_exists?(column)
      return false unless table_exists?

      ActiveRecord::Base.connection.column_exists?(model_name.tableize, column)
    end

    def migration_needed?
      table_exists? && !column_exists?(:subdomain)
    end

    def add_subdomain_field
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      migration_file = "db/migrate/#{timestamp}_add_subdomain_to_#{model_name.tableize}.rb"

      create_file migration_file, <<~RUBY
        class AddSubdomainTo#{model_name.camelize} < ActiveRecord::Migration[#{Rails.version.to_f}]
          def change
            add_column :#{model_name.tableize}, :subdomain, :string, index: true
          end
        end
      RUBY
    end

    def create_initializer
      initializer_file = "config/initializers/multi_tenant_subdomain.rb"

      create_file initializer_file, <<~RUBY
        MultiTenantSubdomain.configure do |config|
          config.tenant_model = "#{model_name}"
        end
      RUBY
    end
  end
end
