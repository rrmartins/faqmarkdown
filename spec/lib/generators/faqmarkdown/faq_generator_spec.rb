require 'spec_helper'

module Faqmarkdown
  describe FaqGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path('../../../../../tmp', __FILE__)

    before do
      prepare_destination

      Faq.stub(:directory) { File.expand_path('tmp/app/faqs') }
      Faq.class_variable_set('@@faqs', nil)
    end

    context 'with the slug parameter' do
      it 'creates a file for the slug and the current date' do
        Timecop.freeze(Time.utc(2012, 1, 1, 10, 20, 30)) do
          run_generator %w(test-faq)

          Dir.glob('tmp/app/faqs/*').should == ['tmp/app/faqs/2012-01-01-102030-test-faq.markdown']

          Faq.all.count.should == 1

          faq = Faq.first
          faq.slug.should == 'test-faq'
          faq.date.should == Date.parse('2012-01-01')
          faq.title.should == 'Test faq'
        end
      end
    end

    context 'with the slug parameter including an underscore' do
      it 'creates the correct file and sets the right values' do
        Timecop.freeze(Time.utc(2012, 1, 1, 10, 20, 30)) do
          run_generator %w(test-faq_with_underscores)

          Dir.glob('tmp/app/faqs/*').should == ['tmp/app/faqs/2012-01-01-102030-test-faq_with_underscores.markdown']

          Faq.all.count.should == 1

          faq = Faq.first
          faq.slug.should == 'test-faq_with_underscores'
          faq.date.should == Date.parse('2012-01-01')
          faq.title.should == 'Test faq_with_underscores'
        end
      end
    end

    context 'with the slug and date parameters' do
      it 'creates a file for the slug and the given date' do
        run_generator %w(other-faq --date=2012-01-02)

        Dir.glob('tmp/app/faqs/*').should == ['tmp/app/faqs/2012-01-02-000000-other-faq.markdown']

        Faq.all.count.should == 1

        faq = Faq.first
        faq.slug.should == 'other-faq'
        faq.date.should == Date.parse('2012-01-02')
        faq.title.should == 'Other faq'
      end
    end

    context 'with the slug, date and time parameters' do
      it 'creates a file for the slug and the given date' do
        run_generator %w(other-faq --date=2012-01-02-102030)

        Dir.glob('tmp/app/faqs/*').should == ['tmp/app/faqs/2012-01-02-102030-other-faq.markdown']

        Faq.all.count.should == 1

        faq = Faq.first
        faq.slug.should == 'other-faq'
        faq.date.should == Time.utc(2012, 01, 02, 10, 20, 30).to_date
        faq.title.should == 'Other faq'
      end
    end

    context 'with invalid slug' do
      it 'raises a system exit exception' do
        lambda { run_generator %w(!test-faq) }.should raise_error(SystemExit)
      end

      it 'does not create the file' do
        Dir['app/faqs/*'].should be_empty
      end
    end

    context 'with invalid date' do
      it 'raises a system exit exception' do
        lambda { run_generator %w(test-faq --date=2012-02) }.should raise_error(SystemExit)
      end

      it 'does not create the file' do
        Dir['app/faqs/*'].should be_empty
      end
    end
  end
end
