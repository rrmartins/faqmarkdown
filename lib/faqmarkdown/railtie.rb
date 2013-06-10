module Faqmarkdown
  class Railtie < Rails::Railtie
    initializer :before_initialize do
      unless Rails.application.config.respond_to?(:assets) && Rails.application.config.assets.enabled
        require 'rack'
        Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static',
          :urls => ['/stylesheets/faqmarkdown'],
          :root => "#{faqmarkdown_root}/vendor/assets"
        )
      end
      ActionController::Base.append_view_path("#{faqmarkdown_root}/app/views")
    end

    private

    def faqmarkdown_root
      File.expand_path(File.dirname(__FILE__) + '/../..')
    end
  end
end
