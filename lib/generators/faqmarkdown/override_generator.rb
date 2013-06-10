module Faqmarkdown
  class OverrideGenerator < Rails::Generators::Base
    desc File.read(File.expand_path('../usage/override.txt', __FILE__))
    source_root File.expand_path('../../../../app', __FILE__)

    class_option :all,        :type => :boolean, :group => :override, :desc => 'Override all of the things'
    class_option :views,      :type => :boolean, :group => :override, :desc => 'Override the Faq views'
    class_option :model,      :type => :boolean, :group => :override, :desc => 'Override the Faq model'
    class_option :controller, :type => :boolean, :group => :override, :desc => 'Override the Faqs controller'
    class_option :theme,      :type => :boolean, :group => :override, :desc => 'Override the layout and stylesheet'

    def check_class_options
      if options.blank?
        exec 'rails g faqmarkdown:override --help'
        exit
      end
    end

    def override_views
      if options.views || options.all
        directory 'views/faqs', 'app/views/faqs'
      end
    end

    def override_model
      if options.model || options.all
        copy_file 'models/faq.rb', 'app/models/faq.rb'
      end
    end

    def override_controller
      if options.controller || options.all
        copy_file 'controllers/faqs_controller.rb', 'app/controllers/faqs_controller.rb'
      end
    end

    def override_theme
      if options.theme || options.all
        directory 'views/layouts', 'app/views/layouts'
        if Rails.application.config.respond_to?(:assets) && Rails.application.config.assets.enabled
          directory '../vendor/assets/stylesheets', 'app/assets/stylesheets'
        else
          directory '../vendor/assets/stylesheets', 'public/stylesheets'
        end
      end
    end
  end
end
