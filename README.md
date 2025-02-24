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

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/sharvy/multi_tenant_subdomain).

## License

The gem is available as open source under the [MIT License](https://opensource.org/licenses/MIT).
