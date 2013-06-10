# encoding: utf-8
class FaqsController < ApplicationController
  layout :choose_layout

  def index
    collection
    require 'pry'
    binding.pry
    respond_to { |format| format.html }
  end

  def show
    resource
    respond_to { |format| format.html }
  end

  def faq_per_category
    collection
    respond_to do |format|
      format.html { render :index }
    end
  end

  def feed
    max_age = 4.hours
    response.headers['Cache-Control'] = 'public, max-age=' + max_age.to_i.to_s
    response.headers['Expires'] = max_age.from_now.httpdate
    response.content_type = 'application/atom+xml'
    fresh_when :last_modified => Faq.feed_last_modified
  end

  protected

  def resource
    @action = 'show'
    @resource ||= Faq.find(params[:id])
  end
  # helper_method :resource

  def collection
    @action = 'index'
    @collection ||= begin
      faqs = if params.include?(:category)
                Faq.find_by_category(params[:category])
              else
                Faq.where(params.slice(:year, :month, :day))
              end
      faqs = Kaminari.paginate_array(faqs).page(params[:page]).per(faqs_per_page)
      faqs
    end
  end
  # helper_method :collection

  private

  def faqs_per_page
    params[:count] || Faqmarkdown::Config.options[:faqs_per_page]
  end

  def choose_layout
    if Faqmarkdown::Config.options[:use_theme]
      ActiveSupport::Deprecation.warn "`Faqmarkdown::Config.options[:use_theme]` is deprecated. Use `Faqmarkdown::Config.options[:layout] = 'faqmarkdown'` instead."
      'Faqmarkdown'
    else
      Faqmarkdown::Config.options[:layout]
    end
  end
end
