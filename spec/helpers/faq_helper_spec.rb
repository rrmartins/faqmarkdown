require 'spec_helper'

describe FaqHelper do
  def test_faq(file_name)
    Faq.new(File.dirname(__FILE__) + "/../support/data/faqs/#{file_name}")
  end

  let(:summary_html) { helper.faq_summary_html(faq) }
  let(:content_html) { helper.faq_content_html(faq) }

  context 'with first faq' do
    let(:faq) { test_faq '2011-04-01-first-faq.markdown' }

    it 'renders HTML content' do
      content_html.should be_html_safe
      content_html.should =~ /^<p>Lorem ipsum/
      content_html.should =~ /^<p>Duis aute irure dolor/
    end

    it 'renders HTML summary' do
      summary_html.should be_html_safe
      summary_html.should =~ /^<p>Lorem ipsum/
      summary_html.should_not =~ /^<p>Duis aute irure dolor/
    end
  end

  context 'with image faq' do
    let(:faq) { test_faq '2011-04-28-image.markdown' }

    it 'renders HTML summary' do
      summary_html.should be_html_safe
      summary_html.should =~ /^<p><img src=\"example.png\">/
    end

    it 'renders HTML content' do
      content_html.should be_html_safe
      content_html.should =~ /^<p><img src="example.png" \/>/
    end
  end

  context 'with custom summary faq' do
    let(:faq) { test_faq '2011-04-28-summary.markdown' }

    it 'renders HTML summary' do
      summary_html.should be_html_safe
      summary_html.should eq '<p>This is a custom &amp; test summary.</p>'
    end
  end
end
