xml.instruct!
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title Faqmarkdown::Config.options[:feed_title]
  xml.link :href => faqs_feed_url, :rel => :self, :type => 'application/atom+xml'
  xml.link :href => faqs_url, :rel => :alternate, :type => 'text/html'
  xml.id faqs_url
  xml.updated Faq.feed_last_modified.xmlschema

  Faq.feed.each do |faq|
    xml.entry do
      xml.title faq.title, :type => :text
      xml.link :href => faq_url(faq), :rel => :alternate, :type => 'text/html'
      xml.published faq.timestamp.xmlschema
      xml.updated faq.last_modified.xmlschema

      if faq.author.present?
        xml.author do
          xml.name faq.author
          xml.email faq.email if faq.email.present?
        end
      end

      xml.id faq_url(faq)
      xml.content :type => :html, 'xml:base' => faq_url(faq) do
        xml.cdata! faq_content_html(faq)
      end
    end
  end
end
