require "rails/generators"
require "active_record"
require "fileutils"

module MultiTenantSubdomain
  class MultiTenantSubdomainGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)
    argument :model_name, type: :string

    def create_model
      return if behavior != :invoke

      unless model_exists?
        generate "model", "#{model_name} subdomain:string:index"
      else
        add_subdomain_field if migration_needed?
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
      initializer_path = Rails.root.join("config", "initializers", "multi_tenant_subdomain.rb")

      unless File.exist?(initializer_path)
        create_file initializer_path, <<~RUBY
          MultiTenantSubdomain.configure do |config|
            config.tenant_model = #{model_name.to_s.camelize}
          end
        RUBY
      else
        puts "X Initializer already exists. Skipping..."
      end
    end

    def remove_initializer
      initializer_path = Rails.root.join("config", "initializers", "multi_tenant_subdomain.rb")
      if File.exist?(initializer_path)
        FileUtils.rm_f(initializer_path)
        puts "X Removed initializer: config/initializers/multi_tenant_subdomain.rb"
      end
    end

    def remove_model
      model_path = Rails.root.join("app", "models", "#{model_name.underscore}.rb")
      test_path = Rails.root.join("test", "models", "#{model_name.underscore}_test.rb")
      spec_path = Rails.root.join("spec", "models", "#{model_name.underscore}_spec.rb")

      [model_path, test_path, spec_path].each do |path|
        FileUtils.rm_f(path) if File.exist?(path)
      end

      puts "X Removed model: #{model_name}"
    end

    def remove_migrations
      migration_files = Dir.glob(Rails.root.join("db", "migrate", "*_#{model_name.tableize}.rb"))
      migration_files.each do |file|
        FileUtils.rm_f(file) if File.exist?(file)
      end

      puts "X Removed migrations related to #{model_name}"
    end
  end
end
