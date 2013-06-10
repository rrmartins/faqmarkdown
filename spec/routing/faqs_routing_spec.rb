require 'spec_helper'

describe FaqsController do
  describe 'default routes' do
    it '/faqs to faqs#index' do
      path = faqs_path
      path.should == '/faqs'
      { :get => path }.should route_to :controller => 'faqs', :action => 'index'
    end

    it '/faqs/2012 to faqs#index with year' do
      path = faqs_path(:year => '2012')
      path.should == '/faqs/2012'
      { :get => path }.should route_to :controller => 'faqs', :action => 'index', :year => '2012'
    end

    it '/faqs/2012/01 to faqs#index with year and month' do
      path = faqs_path(:year => '2012', :month => '01')
      path.should == '/faqs/2012/01'
      { :get => path }.should route_to :controller => 'faqs', :action => 'index', :year => '2012', :month => '01'
    end

    it '/faqs/2012/01/01 to faqs#index with year, month and day' do
      path = faqs_path(:year => '2012', :month => '01', :day => '01')
      path.should == '/faqs/2012/01/01'
      { :get => path }.should route_to :controller => 'faqs', :action => 'index', :year => '2012', :month => '01', :day => '01'
    end

    it '/faqs/2012/01/01/test-faq to faqs#show with permalink a format of day' do
      path = faq_path(:id => '2012/01/01/test-faq')
      path.should == '/faqs/2012/01/01/test-faq'
      { :get => path }.should route_to :controller => 'faqs', :action => 'show', :id => '2012/01/01/test-faq'
    end
  end

  describe 'custom routes' do
    before { Rails.application.routes.clear! }
    after { Rails.application.reload_routes! }

    it '/faq to faqs#index' do
      Rails.application.routes.draw { faqmarkdown :as => :faq }

      path = faqs_path
      path.should == '/faq'
      { :get => path }.should route_to :controller => 'faqs', :action => 'index'
    end

    it '/faq/test-faq to faqs#show with a permalink format of slug' do
      Rails.application.routes.draw { faqmarkdown :as => :faq, :permalink_format => :slug }

      path = faq_path(:id => 'test-faq')
      path.should == '/faq/test-faq'
      { :get => path }.should route_to :controller => 'faqs', :action => 'show', :id => 'test-faq'
    end

    it '/faq/2012/test-faq to faqs#show with a permalink format of year' do
      Rails.application.routes.draw { faqmarkdown :as => :faq, :permalink_format => :year }

      path = faq_path(:id => '2012/test-faq')
      path.should == '/faq/2012/test-faq'
      { :get => path }.should route_to :controller => 'faqs', :action => 'show', :id => '2012/test-faq'
    end

    it '/faq/2012/01/test-faq to faqs#show with permalink a format of month' do
      Rails.application.routes.draw { faqmarkdown :as => :faq, :permalink_format => :month }

      path = faq_path(:id => '2012/01/test-faq')
      path.should == '/faq/2012/01/test-faq'
      { :get => path }.should route_to :controller => 'faqs', :action => 'show', :id => '2012/01/test-faq'
    end

    it '/faq/2012/01/01/test-faq to faqs#show with permalink a format of day' do
      Rails.application.routes.draw { faqmarkdown :as => :faq, :permalink_format => :day }

      path = faq_path(:id => '2012/01/01/test-faq')
      path.should == '/faq/2012/01/01/test-faq'
      { :get => path }.should route_to :controller => 'faqs', :action => 'show', :id => '2012/01/01/test-faq'
    end
  end
end
