require 'spec_helper'

describe 'Faq views', :type => :request do
  before do
    time_travel_to '2011-05-01'
    Faq.reset!
  end

  after { back_to_the_present }

  context 'Faqs#index' do
    context 'default index' do
      before { visit faqs_path }

      it 'should show published faqs' do
        # 2011-05-01-full-metadata (published today)
        page.should have_content('Faq with full metadata')                # title
        page.should have_content('Posted on 1 May 2011')                   # publish date
        page.should have_content('by John Smith')                          # author
        page.should have_content('This is another custom & test summary.') # summary

        # 2011-04-28-summary
        page.should have_content('A Test Faq')                      # title
        page.should have_content('Posted on 28 April 2011')          # publish date
        page.should have_content('This is a custom & test summary.') # summary

        # 2011-04-28-image
        page.should have_content('Image')                   # title
        page.should have_content('Posted on 28 April 2011') # publish date

        # 2011-04-01-first-post
        page.should have_content('First Faq')                 # title
        page.should have_content('Posted on 1 April 2011')     # publish date
        page.should have_content('Lorem ipsum dolor sit amet') # part of summary
      end

      it 'should not show unpublished faqs' do
        # 2015-02-13-custom-title (not published yet)
        page.should_not have_content('This is a custom title') # title
        page.should_not have_content('Content goes here.')     # summary
      end

      it 'should have the correct number of faqs' do
        all('section#faqs article.faq').size.should == 4
      end
    end

    describe 'pagination' do
      def article_titles
        all('article header h1').map(&:text)
      end

      before do
        visit faqs_path(:count => 2)
      end

      it 'returns the latest faqs on the first page' do
        article_titles.should eq [
          'Faq with full metadata',
          'A Test Faq',
        ]
      end

      it 'returns earlier faqs on the second page' do
        click_link 'Next'
        article_titles.should eq [
          'Image',
          'First Faq',
        ]
      end
    end
  end

  context 'Faqs#index with no faqs' do
    it 'should show a message' do
      time_travel_to '2010-05-01'
      visit faqs_path

      page.should have_content('No faqs found.')
      page.should_not have_content('First Faq')
    end
  end

  context 'Faqs#index with year' do
    before { visit faqs_path(:year => '2011') }

    it 'should show faqs inside the date range' do
      page.should have_content('faq with full metadata')
      page.should have_content('A Test Faq')
      page.should have_content('Image')
      page.should have_content('First Faq')
    end
  end

  context 'Faqs#index with year and month' do
    before { visit faqs_path(:year => '2011', :month => '04') }

    it 'should show faqs inside the date range' do
      page.should have_content('A Test Faq')
      page.should have_content('Image')
      page.should have_content('First Faq')
    end

    it 'should not show posts outside the date range' do
      page.should_not have_content('Faq with full metadata')
    end
  end

  context 'Faqs#index with year, month and day' do
    before { visit faqs_path(:year => '2011', :month => '04', :day => '01') }

    it 'should show faqs inside the date range' do
      page.should have_content('First faq')
    end

    it 'should not show faqs outside the date range' do
      page.should_not have_content('A Test Faq')
      page.should_not have_content('Image')
      page.should_not have_content('Faq with full metadata')
    end
  end

  context 'Faqs#show' do
    before { visit faq_path('2011/05/01/full-metadata') }

    it 'should have content' do
      page.should have_content('Faq with full metadata') # title
      page.should have_content('Posted on 1 May 2011')    # publish date
      page.should have_content('by John Smith')           # author

      # body
      page.should have_content('First paragraph of content.')
      page.should have_content('Second paragraph of content.')
    end

    it 'should not show the summary' do
      page.should_not have_content('This is another custom & test summary.')
    end

    it 'should preserve whitespace on code blocks' do
      page.source.should match '<pre><code>First line of code.&#x000A;  Second line of code.&#x000A;</code></pre>'
    end

    it 'should allow calling Rails helpers via ERB tags' do
      page.source.should match('<p>Paragraph created by Rails helper</p>')
    end
  end

  context 'Faqs#feed' do
    before { visit faqs_feed_path }

    it 'should be xml format type' do
      page.response_headers['Content-Type'].should == 'application/atom+xml; charset=utf-8'
    end

    it 'should be valid xml' do
      lambda do
        Nokogiri::XML::Reader(page.source)
      end.should_not raise_error
    end

    it 'should contain the correct number of entries' do
       Nokogiri::XML(page.source).search('entry').size.should == 4
    end

    it 'should contain an entry that is properly constructed' do
      entry = Nokogiri::XML(page.source).search('entry').first

      entry.search('title').text.should == 'Faq with full metadata'
      entry.search('author').first.search('name').text.should == 'John Smith'
      entry.search('author').first.search('email').text.should == 'john.smith@example.com'
      entry.search('published').text.should == '2011-05-01T00:00:00Z'
      entry.search('content').text == "\n      <p>First paragraph of content.</p>\n\n<p>Second paragraph of content.</p>\n\n    "
    end
  end

  context 'Faqs#show with invalid slug' do
    it 'should raise an not found exception' do
      lambda do
        visit faq_path('2011/05/01/invalid')
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'theme' do
    before { @original_layout = Faqmarkdown::Config.options[:layout] }
    after { Faqmarkdown::Config.options[:layout] = @original_layout }

    it 'should use the application layout by default' do
      visit faqs_path
      page.should_not have_content('A faqmarkdown faq')
    end

    it 'should use the Faqmarkdown layout when using theme' do
      ActiveSupport::Deprecation.silence do
        Faqmarkdown::Config.options[:use_theme] = true
        puts faqs_path
        visit faqs_path
        page.should have_content('A faqmarkdown faq')
        Faqmarkdown::Config.options[:use_theme] = false
      end
    end

    it 'should use the built-in layout when the global option is set to true' do
      Faqmarkdown::Config.options[:layout] = 'custom_layout'
      visit faqs_path
      page.should have_content('A custom layout')
    end
  end
end
