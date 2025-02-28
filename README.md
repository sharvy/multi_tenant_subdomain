# MultiTenantSubdomain

A gem that provides subdomain-based multi-tenancy support for Rails applications, using a single database while ensuring tenant isolation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "multi_tenant_subdomain"
```

And then execute:

```bash
bundle install
```

## Usage

1.  **Generate the tenant model:**

    ```bash
    rails generate multi_tenant_subdomain YourTenantModel
    ```

    Replace `YourTenantModel` with the actual name of your tenant model (e.g., `Account`, `Organization`). This generator will:

    - Create a model (if it doesn't exist) with a `subdomain` attribute.
    - Add a migration to add the `subdomain` column to the model's table (if the table exists and the column is missing).
    - Create an initializer to configure the `tenant_model`.

2.  **Configure the tenant model:**

    The generator creates an initializer file `config/initializers/multi_tenant_subdomain.rb` with the following content:

    ```ruby
    MultiTenantSubdomain.configure do |config|
      config.tenant_model = "YourTenantModel"
    end
    ```

    Ensure `YourTenantModel` matches the name of your tenant model.

## Configuration Options

You can configure the following options in the initializer file `config/initializers/multi_tenant_subdomain.rb`:

```ruby
MultiTenantSubdomain.configure do |config|
  config.tenant_model_class = "YourTenantModel" # Default: "Tenant"
  config.tenant_model_table = "your_tenant_models" # Default: "tenants"
  config.tenant_model_pk = "id" # Default: "id"
  config.tenant_model_fk = "your_tenant_model_id" # Default: "tenant_id"
end
```

- `tenant_model_class`: The class name of your tenant model.
- `tenant_model_table`: The table name of your tenant model.
- `tenant_model_pk`: The primary key of your tenant model.
- `tenant_model_fk`: The foreign key used in other models to reference the tenant.

## ActiveRecord Scoping

By default, all your ActiveRecord models are automatically scoped to the current tenant. This is achieved by adding a `default_scope` to your models that filters records based on the current tenant's ID.

To ensure this works correctly, make sure your models have a foreign key column that references your tenant model (e.g., `account_id` if your tenant model is `Account`).

If you need to bypass the tenant scoping for any reason, you can use the `without_tenant_scope` method:

```ruby
YourModel.without_tenant_scope do
  # Your code here will bypass the tenant scoping
  YourModel.all # Returns all records, regardless of the current tenant
end
```

**Note:** Replace `YourModel` with the actual name of your model and `tenant` with the underscored name of your tenant model.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/sharvy/multi_tenant_subdomain).

## License

The gem is available as open source under the [MIT License](https://opensource.org/licenses/MIT).
