module Faqmarkdown
  class InstallGenerator < Rails::Generators::Base
    desc File.read(File.expand_path('../usage/install.txt', __FILE__)).gsub('{{CURRENT_DATE}}', Time.zone.now.strftime('%Y-%m-%d'))
    source_root File.expand_path('../templates', __FILE__)
    class_option :skip_example, :type => :boolean, :group => :runtime, :desc => 'Skip generating an example faq'

    def create_directory
      empty_directory 'app/faqs'
    end

    def generate_example_faq
      generate 'faqmarkdown:faq', 'example-faq' unless options.skip_example?
    end

    def add_routes
      insert_into_file 'config/routes.rb', "  faqmarkdown :as => :faqs\n\n", :after => "::Application.routes.draw do\n"
    end
  end
end
