module FaqHelper
  class Sanitizer < HTML::WhiteListSanitizer
    self.allowed_tags.merge(%w(img a))
  end

  def faq_summary_html(faq)
    if faq.summary.present?
      content_tag :p, faq.summary
    else
      reg = /<!--more-->/
      html_text = faq_content_html(faq)

      html = !((html_text =~ reg).nil?) ? html_text[0..(html_text =~ reg)-1] : html_text
      doc = Nokogiri::HTML.fragment(html)
      doc = doc.search('p').detect { |p| p.text.present? } if (html_text =~ reg).nil?
      doc.try(:to_html).try(:html_safe)
    end
  end

  def faq_content_html(faq)
    RDiscount.new(render(:inline => faq.content)).to_html.html_safe
  end
end
