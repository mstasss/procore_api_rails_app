Rails.application.default_url_options = {
  host: Rails.configuration.default_host,
  port: ENV.fetch('PORT', 4567)
}
Rails.application.routes.default_url_options[:host] = Rails.configuration.default_host
