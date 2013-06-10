require 'spec_helper'

describe Faq do
  def test_faq(file_name)
    Faq.new(File.dirname(__FILE__) + "/../support/data/faqs/#{file_name}")
  end

  it 'should not initialise with bad filename' do
    lambda { test_faq 'missing-date-from-filename.markdown' }.should raise_error
  end

  context 'with missing file' do
    subject { test_faq '2000-01-01-no-such-file.markdown' }
    it 'should error when trying to read content' do
      lambda { subject.content }.should raise_error
    end
  end

  it 'should return the correct directory' do
    Faq.directory.should == Rails.root.join('app', 'faqs')
  end

  context 'with first faq' do
    subject { test_faq '2011-04-01-first-faq.markdown' }
    its(:slug) { should == 'first-faq' }
    its(:date) { should == Date.parse('2011-04-01') }
    its(:title) { should == 'First Faq' }
    its(:content) { should =~ /\ALorem ipsum/ }
  end

  context 'with custom title faq' do
    subject { test_faq '2015-02-13-custom-title.markdown' }
    its(:slug) { should == 'custom-title' }
    its(:date) { should == Date.parse('2015-02-13') }
    its(:title) { should == 'This is a custom title' }
    its(:content) { should == "Content goes here.\n" }
  end

  context 'with a custom title that also and including timestamp' do
    subject { test_faq '2012-02-13-102030-custom-title-and-timestamp.markdown' }
    its(:slug) { should == 'custom-title-and-timestamp' }
    its(:date) { should == Time.utc(2012, 02, 13, 10, 20, 30).to_date }
    its(:title) { should == 'This is a custom title' }
    its(:content) { should == "Content goes here.\n" }
  end

  context 'with a slug containing underscores' do
    subject { test_faq '2012-02-12-102030-slug_containing_underscores.markdown' }
    its(:slug) { should == 'slug_containing_underscores' }
  end

  context 'with author' do
    subject { test_faq '2011-05-01-full-metadata.markdown' }
    its(:author) { should == 'John Smith' }
    its(:email) { should == 'john.smith@example.com' }
  end

  context "with categories" do
    subject { test_faq '2011-05-01-full-metadata.markdown' }
    its(:categories) { should == ['full', 'metadata']}
  end

  context "search per category" do
    it "should return one Faq per search by category 'full'" do
      faqs = Faq.find_by_category('full')
      faqs.class.should == Array
      faqs.first.categories.include?('full').should be_true
      faqs.first.categories.include?('foobar').should be_false
      faqs.first.categories.should == ['full', 'metadata']
      faqs.first.class.should == Faq
      faqs.first.author.should == 'John Smith'
      faqs.first.email.should == 'john.smith@example.com'
    end
  end

  context "all categories" do
    it "should list all categories" do
      categories = Faq.categories_all
      categories.class.should == Array
      categories.should == ["full", "metadata"]
    end

  end

  context 'with custom summary faq' do
    subject { test_faq '2011-04-28-summary.markdown' }
    its(:summary) { should == 'This is a custom & test summary.' }
  end

  context 'with alternate markdown file extension' do
    it 'should accept *.md files' do
      lambda { test_faq('2011-05-02-md-file-extension.md').content }.should_not raise_error
    end

    it 'should accept *.mkd files' do
      lambda { test_faq('2011-05-02-mkd-file-extension.mkd').content }.should_not raise_error
    end

    it 'should accept *.mdown files' do
      lambda { test_faq('2011-05-02-mdown-file-extension.mdown').content }.should_not raise_error
    end
  end
end
