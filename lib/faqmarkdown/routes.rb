class ActionDispatch::Routing::Mapper
  require 'faqmarkdown/util'

  def faqmarkdown(options = {})
    options.reverse_merge!({ :as => :faqs, :permalink_format => :day })

    get "/#{options[:as]}(/:year(/:month(/:day)))" => 'faqs#index', as: :faqs, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/}
    get "/#{options[:as]}/feed" => 'faqs#feed', as: :faqs_feed, :format => :xml
    get "/#{options[:as]}/*id" => 'faqs#show', as: :faq, :constraints => { :id => faqmarkdown_permalink_regex(options) }
    # get "/#{options[:as]}/categoria/:category", as: 'faqs#faq_per_category', as: :faqs_category

    faqmarkdown_feed_title(options[:as])
  end

  private

  def faqmarkdown_permalink_regex(options)
    Faqmarkdown::Config.options[:permalink_format] = options[:permalink_format]
    Faqmarkdown::Config.options[:permalink_regex].try(:[], options[:permalink_format]) or raise_faqmarkdown_permalink_error
  end

  def faqmarkdown_feed_title(path)
    Faqmarkdown::Config.options[:feed_title] ||= "#{Faqmarkdown::Util.app_name} #{path.to_s.tr('/', '_').humanize.titleize}"
  end

  def raise_faqmarkdown_permalink_error
    possible_options = Faqmarkdown::Config.options[:permalink_regex].map { |k,v| k.inspect }.join(', ')
    raise "Faqmarkdown Routing Error: Invalid :permalink_format option #{Faqmarkdown::Config.options[:permalink_format].inspect} - must be one of the following: #{possible_options}"
  end
end
