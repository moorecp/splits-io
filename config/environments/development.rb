Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.reload_classes_only_on_change = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Allow the use of better_errors from the host (not just the container)
  if defined? BetterErrors
    # Private subnets defined by RFC1918 as stated in https://docs.docker.com/v1.5/articles/networking/
    BetterErrors::Middleware.allow_ip! '10.0.0.0/8'
    BetterErrors::Middleware.allow_ip! '172.16.0.0/12'
    BetterErrors::Middleware.allow_ip! '192.168.0.0/16'
  end

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local


  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.log_level = :debug

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  config.action_mailer.default_url_options = {host: 'localhost:3000'}
  config.action_mailer.raise_delivery_errors = false

  config.use_ssl = false
  config.read_only = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  config.file_watcher = ActiveSupport::FileUpdateChecker
end
