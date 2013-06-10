module Faqmarkdown
  class FaqGenerator < Rails::Generators::Base
    desc File.read(File.expand_path('../usage/faq.txt', __FILE__)).gsub('{{CURRENT_DATE}}', Time.zone.now.strftime('%Y-%m-%d'))
    source_root File.expand_path('../templates', __FILE__)
    argument :slug, :type => :string, :required => true
    class_option :date, :type => :string, :group => :runtime, :desc => 'Publish date for the faq'

    def check_slug
      unless slug =~ /^#{Faq::SLUG_FORMAT}$/
        puts 'Invalid slug - valid characters include letters, digits and dashes.'
        exit
      end
    end

    def check_date
      if options.date && options.date !~ /^#{Faq::DATE_FORMAT}$/
        puts 'Invalid date - please use the following format: YYYY-MM-DD, eg. 2011-01-01.'
        exit
      end
    end

    def generate_faq
      template 'example-faq.markdown', "app/faqs/#{publish_date}-#{slug.downcase}.markdown"
    end

    private

    def publish_date
      format = '%Y-%m-%d-%H%M%S'

      if options.date.present?
        date_string = options.date
        date_string += '-000000' unless options.date.match(/(#{Faq::TIME_FORMAT}$)/)
        date = Time.strptime(date_string, format)
      else
        date = Time.zone.now
      end

      date.strftime(format)
    end
  end
end
