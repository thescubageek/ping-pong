require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trueskill
  class Application < Rails::Application
    EARLIEST_DATE = DateTime.new(2015,1,14)
    
    require 'saulabs/trueskill'

    config.time_zone = 'Pacific Time (US & Canada)'
    config.autoload_paths += %W(#{config.root}/lib)
    
    config.after_initialize do
      #Rails.application.routes.default_url_options[:host] = ENV['HOST']
    end
  end
end