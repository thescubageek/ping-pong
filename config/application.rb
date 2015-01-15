require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trueskill
  class Application < Rails::Application
    require 'saulabs/trueskill'

    config.time_zone = 'Pacific Time (US & Canada)'
    config.autoload_paths += %W(#{config.root}/lib)
    console do
      require 'pry'
      config.console = Pry
    end

    config.after_initialize do
      #Rails.application.routes.default_url_options[:host] = ENV['HOST']
    end
  end
end