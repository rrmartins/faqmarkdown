module Faqmarkdown
  module Config
    extend self

    @options = {}
    attr_accessor :options
  end
end

Faqmarkdown::Config.options[:feed_title] = nil

Faqmarkdown::Config.options[:permalink_format] = :day

Faqmarkdown::Config.options[:faqs_per_page] = 5

Faqmarkdown::Config.options[:layout] = 'application'

Faqmarkdown::Config.options[:permalink_regex] = {}
Faqmarkdown::Config.options[:permalink_regex][:day]   = %r[\d{4}/\d{2}/\d{2}/[^/]+]
Faqmarkdown::Config.options[:permalink_regex][:month] = %r[\d{4}/\d{2}/[^/]+]
Faqmarkdown::Config.options[:permalink_regex][:year]  = %r[\d{4}/[^/]+]
Faqmarkdown::Config.options[:permalink_regex][:slug]  = %r[[^/]+]

Faqmarkdown::Config.options[:markdown_file_extensions] = %w(md mkd mdown markdown)
